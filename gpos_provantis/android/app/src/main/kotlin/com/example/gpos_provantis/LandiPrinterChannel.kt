package com.example.gpos_provantis

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.sdksuite.omnidriver.OmniConnection
import com.sdksuite.omnidriver.OmniDriver
import com.sdksuite.omnidriver.api.OnPrintListener
import com.sdksuite.omnidriver.api.Printer
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Bridge between Flutter and the printer built into Landi handheld POS devices
 * (LandiPrinterSDK.aar, "OmniDriver").
 *
 * Channel "landi_printer":
 *   isAvailable                      -> Boolean  (driver connected, printer ready)
 *   printReceipt {text, logo?}       -> null     (logo = PNG/JPEG bytes, printed first)
 *   printText    {text}              -> null
 *   printImage   {image}             -> null     (image = PNG/JPEG bytes)
 *
 * Errors come back as PlatformExceptions with one of these codes:
 *   PRINTER_NOT_READY, PRINTER_BUSY, PRINTER_TIMEOUT, PRINTER_FAILED
 *   (details = the SDK's numeric error code), EXCEPTION.
 *
 * On a device that isn't a Landi handheld the driver never connects, so
 * isAvailable stays false and nothing else is ever attempted.
 */
class LandiPrinterChannel(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "landi_printer"
        private const val TAG = "LandiPrinter"

        // How long a print job may run before we give up waiting for the SDK.
        private const val JOB_TIMEOUT_MS = 30_000L

        // Don't hammer the driver with reconnect attempts (Dart polls
        // isAvailable every 250 ms while it waits).
        private const val RECONNECT_MIN_INTERVAL_MS = 5_000L
    }

    private val mainHandler = Handler(Looper.getMainLooper())

    private var omniDriver: OmniDriver? = null

    // Set from the SDK's connection callback, read from the main thread.
    @Volatile
    private var printer: Printer? = null

    private var lastConnectAttemptMs = 0L
    private var busy = false

    /** Call from MainActivity.configureFlutterEngine. */
    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(this)
        connect()
    }

    // ---- Connection --------------------------------------------------------

    private fun connect() {
        val now = System.currentTimeMillis()
        if (now - lastConnectAttemptMs < RECONNECT_MIN_INTERVAL_MS) return
        lastConnectAttemptMs = now

        try {
            // The constructor isn't public in the SDK, hence the reflection.
            val constructor =
                OmniDriver::class.java.getDeclaredConstructor(Context::class.java)
            constructor.isAccessible = true
            val driver = constructor.newInstance(context.applicationContext)
            omniDriver = driver

            driver.init(object : OmniConnection {
                override fun onConnected() {
                    Log.d(TAG, "OmniDriver connected")
                    try {
                        val bundle = Bundle()
                        bundle.putInt("type", 0)
                        printer = driver.getPrinter(bundle)
                        if (printer == null) {
                            Log.e(TAG, "Printer is null after connecting")
                        } else {
                            Log.d(TAG, "Printer obtained")
                        }
                    } catch (t: Throwable) {
                        Log.e(TAG, "getPrinter error: ${t.message}")
                    }
                }

                override fun onDisconnected(error: Int) {
                    Log.e(TAG, "OmniDriver disconnected: $error")
                    printer = null
                }
            })
        } catch (t: Throwable) {
            // Expected on anything that isn't a Landi handheld.
            Log.e(TAG, "OmniDriver init error: ${t.message}")
        }
    }

    // ---- MethodChannel -----------------------------------------------------

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAvailable" -> {
                if (printer == null) connect() // throttled; retries after a drop
                result.success(printer != null)
            }
            "printReceipt" -> printJob(
                result,
                logo = call.argument<ByteArray>("logo"),
                text = call.argument<String>("text"),
            )
            "printText" -> printJob(result, logo = null, text = call.argument<String>("text"))
            "printImage" -> printJob(result, logo = call.argument<ByteArray>("image"), text = null)
            else -> result.notImplemented()
        }
    }

    /**
     * Queues the optional image and the text into ONE print job, then prints.
     * Replies exactly once, on the main thread, whatever happens.
     */
    private fun printJob(result: MethodChannel.Result, logo: ByteArray?, text: String?) {
        val p = printer
        if (p == null) {
            connect()
            result.error("PRINTER_NOT_READY", "Printer service not available", null)
            return
        }
        if (busy) {
            result.error("PRINTER_BUSY", "A print job is already running", null)
            return
        }
        busy = true

        val done = AtomicBoolean(false)
        val timeout = Runnable {
            if (done.compareAndSet(false, true)) {
                busy = false
                result.error("PRINTER_TIMEOUT", "Printer did not respond", null)
            }
        }
        // The SDK may call back on a binder thread; Flutter replies must be on main.
        fun finish(reply: () -> Unit) {
            if (done.compareAndSet(false, true)) {
                mainHandler.removeCallbacks(timeout)
                mainHandler.post {
                    busy = false
                    reply()
                }
            }
        }

        try {
            p.openDevice(0)

            if (logo != null && logo.isNotEmpty()) {
                // A logo that can't be decoded must not stop the receipt.
                val png = flattenOnWhite(logo)
                if (png != null) p.addImage(png, 1, 0) else Log.w(TAG, "Logo skipped: undecodable")
            }
            if (!text.isNullOrEmpty()) {
                p.addText(text, 0, 0)
            }

            mainHandler.postDelayed(timeout, JOB_TIMEOUT_MS)
            p.startPrint(object : OnPrintListener {
                override fun onSuccess() {
                    finish { result.success(null) }
                }

                override fun onFail(error: Int) {
                    Log.e(TAG, "Print failed, code $error")
                    finish { result.error("PRINTER_FAILED", "Failed with code: $error", error) }
                }
            })
        } catch (t: Throwable) {
            Log.e(TAG, "Print exception: ${t.message}")
            finish { result.error("EXCEPTION", t.message, null) }
        }
    }

    /**
     * Thermal printers print transparent pixels as black. Paint the logo onto a
     * white background and hand the SDK a PNG.
     */
    private fun flattenOnWhite(bytes: ByteArray): ByteArray? {
        val source = BitmapFactory.decodeByteArray(bytes, 0, bytes.size) ?: return null
        val flat = Bitmap.createBitmap(source.width, source.height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(flat)
        canvas.drawColor(Color.WHITE)
        canvas.drawBitmap(source, 0f, 0f, null)

        val out = ByteArrayOutputStream()
        flat.compress(Bitmap.CompressFormat.PNG, 100, out)
        source.recycle()
        flat.recycle()
        return out.toByteArray()
    }
}
