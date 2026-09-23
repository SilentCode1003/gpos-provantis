//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import flutter_thermal_printer
import screen_retriever_macos
import shared_preferences_foundation
import sqlite3_flutter_libs
import universal_ble
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FlutterThermalPrinterPlugin.register(with: registry.registrar(forPlugin: "FlutterThermalPrinterPlugin"))
  ScreenRetrieverMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  Sqlite3FlutterLibsPlugin.register(with: registry.registrar(forPlugin: "Sqlite3FlutterLibsPlugin"))
  UniversalBlePlugin.register(with: registry.registrar(forPlugin: "UniversalBlePlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
