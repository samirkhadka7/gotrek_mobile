package com.samir.gotrek.gotrek

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class BarometerChannel(private val context: Context) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL = "com.samir.gotrek/barometer"
    }

    private var sensorManager: SensorManager? = null
    private var pressureSensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    private val sensorListener = object : SensorEventListener {
        override fun onSensorChanged(event: SensorEvent) {
            if (event.sensor.type == Sensor.TYPE_PRESSURE) {
                // Send pressure in hPa (hectopascals)
                eventSink?.success(event.values[0].toDouble())
            }
        }

        override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        pressureSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_PRESSURE)

        if (pressureSensor == null) {
            sink.error("SENSOR_NOT_FOUND", "Barometer sensor not available", null)
            return
        }

        sensorManager?.registerListener(
            sensorListener,
            pressureSensor,
            SensorManager.SENSOR_DELAY_UI,
        )
    }

    override fun onCancel(arguments: Any?) {
        sensorManager?.unregisterListener(sensorListener)
        eventSink = null
    }
}
