package com.example.gpos_provantis

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Built-in printer of Landi handhelds (does nothing on other devices).
        LandiPrinterChannel(applicationContext)
            .register(flutterEngine.dartExecutor.binaryMessenger)
    }
}
