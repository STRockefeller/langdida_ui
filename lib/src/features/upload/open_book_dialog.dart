import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:langdida_ui/src/features/book/book.dart';

class OpenBookDialog extends StatefulWidget {
  final String _fileContent;
  const OpenBookDialog(this._fileContent, {super.key});

  @override
  State<OpenBookDialog> createState() => _OpenBookDialogState();
}

class _OpenBookDialogState extends State<OpenBookDialog> {
  final GetStorage _storage = GetStorage();
  String _selectedLanguage = "";
  _OpenBookDialogState() : super() {
    _selectedLanguage = _storage.read("language") ?? "en";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Language"),
      content: DropdownButton<String>(
        value: _selectedLanguage,
        onChanged: (String? newValue) {
          setState(() {
            _selectedLanguage = newValue ?? "en";
          });
        },
        items: <String>['en', 'jp', 'fr']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            _storage.write("language", _selectedLanguage);
            _storage.write("book", widget._fileContent);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookPage(
                          key: UniqueKey(),
                        )));
          },
        ),
      ],
    );
  }
}
