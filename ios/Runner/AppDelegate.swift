import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		let controller = window?.rootViewController as! FlutterViewController
		let batteryChannel = FlutterMethodChannel(name: "domain/battery", binaryMessenger: controller.binaryMessenger)

		batteryChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
			// This method is invoked on the UI thread.
			// Handle battery messages.
			print("Receive message: \(result)")

			guard call.method == "getBatteryLevel" else {
				result(FlutterMethodNotImplemented)
				return
			}

			self?.receiveBatteryLevel(result: result)
		})


		GeneratedPluginRegistrant.register(withRegistry: self)
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}

extension AppDelegate {
	private func receiveBatteryLevel(result: FlutterResult) {
		let device = UIDevice.current
		device.isBatteryMonitoringEnabled = true

		if device.batteryState == UIDevice.BatteryState.unknown {
			result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available", details: nil))
		} else {
			result(Int(device.batteryLevel * 100))
		}
	}
}
