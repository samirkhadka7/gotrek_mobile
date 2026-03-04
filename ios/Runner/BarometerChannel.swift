import Foundation
import CoreMotion
import Flutter

class BarometerChannel: NSObject, FlutterStreamHandler {
    static let CHANNEL = "com.samir.gotrek/barometer"

    private let altimeter = CMAltimeter()
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            events(FlutterError(code: "SENSOR_NOT_FOUND", message: "Barometer sensor not available", details: nil))
            return nil
        }

        altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, error in
            if let error = error {
                self?.eventSink?(FlutterError(code: "SENSOR_ERROR", message: error.localizedDescription, details: nil))
                return
            }
            if let data = data {
                // Send pressure in hPa (kPa * 10 = hPa)
                let pressureHPa = data.pressure.doubleValue * 10.0
                self?.eventSink?(pressureHPa)
            }
        }

        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        altimeter.stopRelativeAltitudeUpdates()
        eventSink = nil
        return nil
    }
}
