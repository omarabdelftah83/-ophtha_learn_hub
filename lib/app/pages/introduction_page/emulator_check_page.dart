import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class EmulatorCheckPage extends StatefulWidget {
  static const String pageName = '/emulator-check-page';

  const EmulatorCheckPage({super.key});

  @override
  _EmulatorCheckPageState createState() => _EmulatorCheckPageState();
}

class _EmulatorCheckPageState extends State<EmulatorCheckPage> {
  bool? isEmulator;

  @override
  void initState() {
    super.initState();
    checkIfEmulator();
  }

  Future<void> checkIfEmulator() async {
    final deviceInfo = DeviceInfoPlugin();
    bool emulatorDetected = false;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      emulatorDetected = androidInfo.isPhysicalDevice == false;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      emulatorDetected = iosInfo.isPhysicalDevice == false;
    }

    setState(() {
      isEmulator = emulatorDetected;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isEmulator == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }


      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, size: 80, color: Colors.red),
              SizedBox(height: 20),
              Text(
                "عذرًا، لا يمكن تشغيل التطبيق على محاكي.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );



  }
}
