import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mobileIP;



  // TODO GETTING MOBILE IP ADDRESS
  mobileIpAddress() async {
    try {
      for (var interface in await NetworkInterface.list()) {
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
    }
  }

  @override
  void initState() {
    super.initState();
    // serverApi();
    mobileIpAddress();
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
