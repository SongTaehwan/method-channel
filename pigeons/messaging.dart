import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/my_message.g.dart',
  kotlinOut: 'android/app/src/main/kotlin/com/example/pigeons/my_message.g.kt',
  kotlinOptions: KotlinOptions(),
  swiftOut: 'ios/Runner/my_message.g.swift',
))
class MyMessage {
  final String title;
  final String body;
  final String email;

  MyMessage(this.title, this.body, this.email);
}

// 네이티브에서 정의할 API
@HostApi()
abstract class MessageApi {
  List<MyMessage> getMessages(String fromEmail);
}
