import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

abstract class ListItem {
  Widget buildTitle(BuildContext ctx);
  Widget buildSubTitle(BuildContext ctx);
}

class ScanResultItem implements ListItem {
  final String devName;
  final String devDescription;
  final String devId;

  ScanResultItem(this.devName, this.devDescription, this.devId);

  @override
  Widget buildSubTitle(BuildContext ctx) {
    return Text(devName);
  }

  @override
  Widget buildTitle(BuildContext ctx) {
    return Text(devDescription);
  }
}

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
    ble
        .scanForDevices(
            withServices: [Uuid.parse("f210ebaa-2f9c-2611-8a37-693fe21f2100")],
            scanMode: ScanMode.lowLatency)
        .timeout(const Duration(seconds: 2), onTimeout: (_) {})
        .listen((device) {
          if (!_bleScanResult.any((dev) => device.id == dev.devId)) {
            setState(() {
              _bleScanResult = [
                ..._bleScanResult,
                ScanResultItem(device.name, "It works!", device.id)
              ];
            });
          }
        });
  }
}
