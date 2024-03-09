import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shelf/shelf.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
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
}


Future<void> serverApi() async {
  Response handler(Request request) {
    print("Request $request");
    if (request.url.path == 'hello') {
      var jsonResponse = jsonEncode({'msg': 'Hello, World!'});
      // _showNotification('Notification', 'Hello, World!');
      return Response.ok(jsonResponse,
          headers: {'content-type': 'application/json'});
    }
    return Response.notFound('Not Found');
  }

  var serverIp = InternetAddress.anyIPv4;
  print("Ip Address $serverIp");

  var server = await shelf_io.serve(handler, serverIp, 8081);
  print('Server running on ${server.address}:${server.port}');
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance serviceInstance) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

Future<void> onStart(ServiceInstance serviceInstance) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

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

    Timer.periodic(const Duration(seconds: 60), (timer) async {
      if (serviceInstance is AndroidServiceInstance) {
        if (await serviceInstance.isForegroundService()) {
          serviceInstance.setForegroundNotificationInfo(
              title: "Codebase", content: "Foreground Service");
        }
      }

      print("Background Service is Running");
      serviceInstance.invoke('update');
    });
  }
}
