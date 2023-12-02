import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		let controller = window?.rootViewController as! FlutterViewController

		configureMethodChannel(binaryMessenger: controller.binaryMessenger)
		configurePigeonSetup(binaryMessenger: controller.binaryMessenger)

		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}

extension AppDelegate {
	private func configureMethodChannel(binaryMessenger: FlutterBinaryMessenger) {
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

		GeneratedPluginRegistrant.register(with: self)
	}

	private func configurePigeonSetup(binaryMessenger: FlutterBinaryMessenger) {
		MessageApiSetup.setUp(binaryMessenger: binaryMessenger, api: MyMessageApi())
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

class MyMessageApi: MessageApi {
	private let messages = [
		MyMessage(title: "Tom", body: "Hello1", email: "hi@flow.com"),
		MyMessage(title: "Dom", body: "Hello2", email: "hi@flow.com"),
		MyMessage(title: "Gom", body: "Hello3", email: "hi@flow.com"),
		MyMessage(title: "Qom", body: "Hello4", email: "hi@flow.com"),
	]

	func getMessages(fromEmail: String) throws -> [MyMessage] {
		return messages.filter { $0.email == fromEmail }
	}

}
