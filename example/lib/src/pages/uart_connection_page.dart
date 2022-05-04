import 'package:flutter/material.dart';
import 'package:flutter_rtklib_example/src/controllers/uart_controller.dart';
import 'package:flutter_rtklib_example/src/pages/settings_page.dart';
import 'package:flutter_rtklib_example/src/widgets/app_drawer.dart';
import 'package:get/get.dart';

class UartConnectionPage extends StatefulWidget {
  static const routeName = '/uart';

  const UartConnectionPage({Key? key}) : super(key: key);

  @override
  State<UartConnectionPage> createState() => _UartConnectionPageState();
}

class _UartConnectionPageState extends State<UartConnectionPage> {
  final UartController uartController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uart connection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsPage.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Scrollbar(
        child: ListView(
          children: [
            for (final address in uartController.availablePorts.value)
              Builder(builder: (context) {
                final port = uartController.getPort(address);
                return ExpansionTile(
                  title: Text(address),
                  children: [
                    CardListTile(name: 'Description', value: port.description),
                    CardListTile(
                        name: 'Transport', value: port.transport.toTransport()),
                    CardListTile(
                        name: 'USB Bus', value: port.busNumber?.toPadded()),
                    CardListTile(
                        name: 'USB Device',
                        value: port.deviceNumber?.toPadded()),
                    CardListTile(
                        name: 'Vendor ID', value: port.vendorId?.toHex()),
                    CardListTile(
                        name: 'Product ID', value: port.productId?.toHex()),
                    CardListTile(
                        name: 'Manufacturer', value: port.manufacturer),
                    CardListTile(name: 'Product Name', value: port.productName),
                    CardListTile(
                        name: 'Serial Number', value: port.serialNumber),
                    CardListTile(name: 'MAC Address', value: port.macAddress),
                  ],
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: uartController.updateAvailablePorts,
      ),
    );
  }
}

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  const CardListTile({Key? key, required this.name, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}
