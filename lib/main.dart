import 'package:flutter/material.dart';
import 'package:langdida_ui/src/features/book/book.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:langdida_ui/src/features/settings/settings.dart';
import 'package:langdida_ui/src/features/upload/upload.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();
  box.listenKey("server_address", (value) {
    print("server_address changed to $value");
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Widget _homePage;

  MyApp({Key? key})
      : _homePage = GetStorage().read("server_address") == null
            ? SettingsPage(key: UniqueKey())
            : GetStorage().read("book") == null
                ? UploadPage(key: UniqueKey())
                : BookPage(key: UniqueKey()),
        super(key: key);

  // const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LangDiDa',
      theme: FlexThemeData.light(scheme: FlexScheme.deepPurple),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepPurple),
      themeMode: ThemeMode.system,
      home: _homePage,
    );
  }
}
