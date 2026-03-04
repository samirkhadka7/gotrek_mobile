import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let barometerChannel = FlutterEventChannel(
      name: BarometerChannel.CHANNEL,
      binaryMessenger: controller.binaryMessenger
    )
    barometerChannel.setStreamHandler(BarometerChannel())

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
