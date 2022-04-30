import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_rtklib/flutter_rtklib.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key) {
    ublox = UbloxImpl();
  }
  late final UbloxImpl ublox;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  late final StreamSubscription<ObservationControllerImpl>
      obsStreamSubscription;
  @override
  void initState() {
    super.initState();
    initPlatformState();

    obsStreamSubscription = widget.ublox.observationStream.handleError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }).listen((obs) {
      if (kDebugMode) {
        //print(obs.toString());
      }
    });
    testUbx2();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await FlutterRtklib.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  /*

  Future<void> testUbx() async {
    final bytes = await rootBundle.load('assets/data/RAW_15.UBX');
    final buffer =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    for (int i = 0; i < buffer.length; i++) {
      final res = widget.ublox.test_input_ubx(buffer[i]);
      if (res == 1) {
        if (kDebugMode) {
          print(res.toString());
        }
      }
    }
    //ublox.print_raw();
  }

  */

  Future<void> testUbx2() async {
    final bytes = await rootBundle.load('assets/data/ubx_20080526.ubx');
    final buffer =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    widget.ublox.input_ubx(buffer);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    obsStreamSubscription.cancel();
    super.dispose();
  }
}
