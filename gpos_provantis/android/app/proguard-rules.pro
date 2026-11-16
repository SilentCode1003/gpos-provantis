# Landi printer SDK. LandiPrinterChannel reaches into OmniDriver by reflection,
# so release builds (R8) must not rename or strip it.
-keep class com.sdksuite.omnidriver.** { *; }
-dontwarn com.sdksuite.omnidriver.**
