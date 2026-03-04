package com.samir.gotrek.gotrek

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LightSensorChannel.CHANNEL,
        ).setStreamHandler(LightSensorChannel(applicationContext))

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BarometerChannel.CHANNEL,
        ).setStreamHandler(BarometerChannel(applicationContext))
    }
}
