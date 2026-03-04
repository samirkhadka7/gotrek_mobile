package com.samir.gotrek.gotrek

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class LightSensorChannel(private val context: Context) : EventChannel.StreamHandler {

    companion object {
        const val CHANNEL = "com.samir.gotrek/light_sensor"
    }

    private var sensorManager: SensorManager? = null
    private var lightSensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null

    private val sensorListener = object : SensorEventListener {
        override fun onSensorChanged(event: SensorEvent) {
            if (event.sensor.type == Sensor.TYPE_LIGHT) {
                eventSink?.success(event.values[0].toInt())
            }
        }

        override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        lightSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_LIGHT)

        if (lightSensor == null) {
            sink.error("SENSOR_NOT_FOUND", "Ambient light sensor not available", null)
            return
        }

        sensorManager?.registerListener(
            sensorListener,
            lightSensor,
            SensorManager.SENSOR_DELAY_FASTEST,
        )
    }

    override fun onCancel(arguments: Any?) {
        sensorManager?.unregisterListener(sensorListener)
        eventSink = null
    }
}
