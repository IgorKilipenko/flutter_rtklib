import 'package:flutter/material.dart';
import 'package:flutter_rtklib_example/src/page_routes.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key, List<Widget>? customItems})
      : _customItems = customItems,
        super(key: key);
  final _items = PageRoutes.getRoutes();
  final List<Widget>? _customItems;

  List<Widget> _buildList() {
    final navigationItems = <Widget>[const Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 0.0),
      child: Text('Navigation'),
    ), const Divider()];
    final customItems = <Widget>[];

    for (final navItem in _items) {
      navigationItems.add(ListTile(
          title: Text(navItem == '/' ? "Home" : navItem.replaceFirst(RegExp(r'^/+'), '')),
          leading: const CircleAvatar(
            foregroundImage: AssetImage('assets/images/flutter_logo.png'),
          ),
          onTap: () {
            Get.toNamed(navItem
                .toLowerCase()
                .replaceAll('SampleView'.toLowerCase(), ''));
          }));
    }

    if (_customItems == null || _customItems!.isEmpty) {
      return navigationItems;
    }
    for (final customItem in _customItems!) {
      navigationItems.add(customItem);
    }

    return [...navigationItems, const Divider(), ...customItems];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          controller: ScrollController(),
          restorationId: 'drawerItems',
          children: _buildList(),
        ));
  }
}
