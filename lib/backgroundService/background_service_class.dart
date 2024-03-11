import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  try {
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
      ),
    );
    await serverApi();
  } catch (e) {
    print('Failed to initialize background service: $e');
  }
}

Future<void> serverApi() async {
  Response handler(Request request) {
    if (request.url.path == 'hello') {
      var jsonResponse = jsonEncode({'msg': 'Hello, World!'});
      return Response.ok(jsonResponse,
          headers: {'content-type': 'application/json'});
    }
    return Response.notFound('Not Found');
  }

  var serverIp = InternetAddress.anyIPv4;
  print("SeverIP is ${serverIp.address}");
  var server = await shelf_io.serve(handler, serverIp, 8080, shared: true);
  print("Server is running $server");
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance serviceInstance) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

Future<void> onStart(ServiceInstance serviceInstance) async {
  DartPluginRegistrant.ensureInitialized();
  await serverApi();

  if (serviceInstance is AndroidServiceInstance) {
    serviceInstance.on('setAsForeground').listen((event) {
      serviceInstance.setAsForegroundService();
    });

    serviceInstance.on('setAsBackground').listen((event) {
      serviceInstance.setAsBackgroundService();
    });

    serviceInstance.on('stopService').listen((event) {
      serviceInstance.stopSelf();
    });
  }
}
