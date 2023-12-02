// Autogenerated from Pigeon (v14.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct MyMessage {
  var title: String
  var body: String
  var email: String

  static func fromList(_ list: [Any?]) -> MyMessage? {
    let title = list[0] as! String
    let body = list[1] as! String
    let email = list[2] as! String

    return MyMessage(
      title: title,
      body: body,
      email: email
    )
  }
  func toList() -> [Any?] {
    return [
      title,
      body,
      email,
    ]
  }
}
private class MessageApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return MyMessage.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class MessageApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? MyMessage {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class MessageApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return MessageApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return MessageApiCodecWriter(data: data)
  }
}

class MessageApiCodec: FlutterStandardMessageCodec {
  static let shared = MessageApiCodec(readerWriter: MessageApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol MessageApi {
  func getMessages(fromEmail: String) throws -> [MyMessage]
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class MessageApiSetup {
  /// The codec used by MessageApi.
  static var codec: FlutterStandardMessageCodec { MessageApiCodec.shared }
  /// Sets up an instance of `MessageApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: MessageApi?) {
    let getMessagesChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.batterylevel.MessageApi.getMessages", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getMessagesChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let fromEmailArg = args[0] as! String
        do {
          let result = try api.getMessages(fromEmail: fromEmailArg)
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getMessagesChannel.setMessageHandler(nil)
    }
  }
}
