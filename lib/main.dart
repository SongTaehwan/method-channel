import 'dart:async';
import 'package:batterylevel/my_message.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(home: MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('domain/battery');

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;

    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = "Battery level at $result %";
    } on MissingPluginException {
      batteryLevel = "Missing plugin";
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Get Battery Level',
                    textDirection: TextDirection.ltr),
              ),
              Text(_batteryLevel),
              const MessageViewer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageViewer extends StatefulWidget {
  const MessageViewer({super.key});

  @override
  State<MessageViewer> createState() => _MessageViewerState();
}

class _MessageViewerState extends State<MessageViewer> {
  List<MyMessage?> messages = [];
  final api = MessageApi();

  Future<void> _getMessage() async {
    final result = await api.getMessages("hi@flow.com");
    setState(() {
      messages = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _getMessage,
          child: const Text(
            "Fetch Messages",
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.amberAccent,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              final item = messages[index];

              if (item == null) {
                return const Text("EMPTY");
              }

              return Column(
                children: [
                  Text(item.title),
                  Text(item.body),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
