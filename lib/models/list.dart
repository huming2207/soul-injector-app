import 'package:flutter/material.dart';

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
