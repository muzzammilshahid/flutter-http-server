import 'dart:io';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mobileIP;

  // Method to get the mobile IP address
  void getMobileIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            setState(() {
              mobileIP = addr.address;
              print('Mobile IP Address: ${addr.address}');
            });
          }
        }
      }
    } catch (e) {
      print('Failed to get IP address: $e');
      setState(() {
        mobileIP = 'Error occurred: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMobileIpAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dart Api"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 45.0),
            child: ListTile(
              leading: const Text(
                "Mobile IP Address",
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              ),
              title: mobileIP != null
                  ? Text(
                      mobileIP!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700),
                    )
                  : const Text(
                      "IP is null",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
