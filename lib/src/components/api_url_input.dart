import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/utils/connections.dart';

class ServerAddressInput extends StatelessWidget {
  ServerAddressInput({required Key key}) : super(key: key);

  final GetStorage _storage = GetStorage();
  final TextEditingController controller = TextEditingController();
  void onSubmit(BuildContext context) {
    String serverAddress = controller.text.trim();
    if (serverAddress.isNotEmpty) {
      // save the server address
      _storage.write('server_address', serverAddress);
      // connect to the server
      Connections.isConnected().then((ok) => {
            if (ok)
              {
                showFlashMessage(context, "Connected to $serverAddress")
              }
            else
              {
                showFlashMessage(context, "Failed to connected to $serverAddress")
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller
              ..text = _storage.read('server_address') ?? '',
            decoration: const InputDecoration(
              labelText: 'Server IP Address',
              hintText: 'Enter the server IP address',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => onSubmit(context),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}
