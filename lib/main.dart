import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'backgroundService/background_service_class.dart';
import 'home_screen.ddart.dart';



void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final PermissionStatus permissionStatus = await Permission.notification.request();
  if (permissionStatus == PermissionStatus.granted) {
    await initializeService();
  } else {
    print('Notification permission denied. Background service will not be started.');
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP SERVER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Foreground Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Foreground Example Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   static const platform = MethodChannel('example_service');
//   String _serverState = 'Did not make the call yet';
//
//
//   // TODO SERVER API
//   serverApi() async {
//     // Create a Shelf handler that responds with JSON message to /hello requests.
//     handler(Request request) {
//       if (request.url.path == 'hello') {
//         var jsonResponse = jsonEncode({'msg': 'Hello, World!'});
//         return Response.ok(jsonResponse,
//             headers: {'content-type': 'application/json'});
//       }
//       return Response.notFound('Not Found');
//     }
//
//     // Get the IP address of the machine
//     var serverIp = InternetAddress.anyIPv4;
//
//     // Start the server on the IP address of the machine and port 8080.
//     var server = await shelf_io.serve(handler, serverIp, 8080);
//     print('Server running on ${server.address}:${server.port}');
//   }
//
//   Future<void> _startService() async {
//     try {
//       final result = await platform.invokeMethod('startExampleService');
//       setState(() {
//         _serverState = result;
//         serverApi();
//       });
//     } on PlatformException catch (e) {
//       print("Failed to invoke method: '${e.message}'.");
//     }
//   }
//
//   Future<void> _stopService() async {
//     try {
//       final result = await platform.invokeMethod('stopExampleService');
//       setState(() {
//         _serverState = result;
//       });
//     } on PlatformException catch (e) {
//       print("Failed to invoke method: '${e.message}'.");
//     }
//   }
//
//
//   // TODO GETTING MOBILE IP ADDRESS
//   mobileIpAddress() async {
//     try {
//       for (var interface in await NetworkInterface.list()) {
//         for (var addr in interface.addresses) {
//           if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
//             setState(() {
//               // mobileIP = addr.address;
//               print('Mobile IP Address: ${addr.address}');
//             });
//           }
//         }
//       }
//     } catch (e) {
//       print('Failed to get IP address: $e');
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     mobileIpAddress();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_serverState),
//             MaterialButton(
//               onPressed: _startService,
//               child: const Text('Start Service'),
//
//             ),
//             MaterialButton(
//               onPressed: _stopService,
//               child: const Text('Stop Service'),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





