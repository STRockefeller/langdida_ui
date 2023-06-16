import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:langdida_ui/src/features/upload/open_book_dialog.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final GetStorage _storage = GetStorage();
  final TextEditingController _urlController = TextEditingController();
  String _fileContent = "";

  void _sendUrlToApi() async {
    String url = _urlController.text;
    dynamic responseBody;
    String content;
    http
        .get(Uri.parse(
            _storage.read("server_address") + "/io/import/url?url=$url"))
        .then((resp) => {
              responseBody = json.decode(resp.body),
              content = responseBody['content'] as String,
              showFlashMessage(context, content),
              _fileContent = content,
              setState(() {})
            })
        .catchError((e) {
      showFlashMessage(context, e.toString());
      return <void>{};
    });
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      if (kIsWeb) {
        // On web platform, use bytes property to access file content
        _fileContent = utf8.decode(file.bytes!);
      } else {
        // On other platforms, use path property to access file content
        _fileContent = await File(file.path!).readAsString();
      }
      setState(() {});
    } else {
      showFlashMessage(context, "Canceled");
    }
  }

  void _openBook(String contents) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OpenBookDialog(_fileContent, key: UniqueKey());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Upload", context),
      body: Column(
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Enter URL',
            ),
          ),
          ElevatedButton(
            onPressed: _sendUrlToApi,
            child: const Text('New Lesson from URL'),
          ),
          ElevatedButton(
            onPressed: _selectFile,
            child: const Text('Select File'),
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Text(_fileContent.isEmpty
                  ? 'ContentsPreview'
                  : 'File content: $_fileContent'),
            ),
          ),
          ElevatedButton(
            onPressed: () => _openBook(_fileContent),
            child: const Text('New Lesson from the File'),
          ),
        ],
      ),
    );
  }
}
