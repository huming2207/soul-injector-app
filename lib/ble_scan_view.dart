import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'models/list.dart';

class BleScanResultScreen extends StatefulWidget {
  const BleScanResultScreen({Key? key}) : super(key: key);

  @override
  State<BleScanResultScreen> createState() => BleScanResultScreenState();
}

class BleScanResultScreenState extends State<BleScanResultScreen> {
  final ble = FlutterReactiveBle();

  List<ScanResultItem> _bleScanResult = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: ListView.builder(
          itemCount: _bleScanResult.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(_bleScanResult[index].devName),
                subtitle: Text(_bleScanResult[index].devDescription),
                leading: const Icon(Icons.bluetooth));
          },
        ),
        onRefresh: _pullToRefresh);
  }

  Future<void> _pullToRefresh() async {
    final stream = ble.scanForDevices(
        withServices: [Uuid.parse("f210ebaa-2f9c-2611-8a37-693fe21f2100")],
        scanMode: ScanMode.lowLatency).listen((device) {
      if (!_bleScanResult.any((dev) => device.id == dev.devId)) {
        setState(() {
          _bleScanResult = [
            ..._bleScanResult,
            ScanResultItem(device.name, device.id, device.id)
          ];
        });
      }
    });

    Timer(const Duration(seconds: 3), () => {stream.cancel()});
  }
}
