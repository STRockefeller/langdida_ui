import 'package:flutter/material.dart';
import 'package:langdida_ui/src/features/book/book.dart';
import 'package:langdida_ui/src/features/graph_view/graph_view.dart';
import 'package:langdida_ui/src/features/review/review.dart';
import 'package:langdida_ui/src/features/upload/upload.dart';
import 'package:langdida_ui/src/features/settings/settings.dart';

AppBar newLangDiDaAppBar(String title, BuildContext context) {
  return AppBar(
    title: Text(title),
    // buttons redirect to different pages (Reading, Reviewing, Uploading, Logs, and Settings)
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookPage(
                              key: UniqueKey(),
                            )));
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.abc),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReviewPage(
                              key: UniqueKey(),
                            )));
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadPage(
                              key: UniqueKey(),
                            )));
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GraphViewPage()));
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.bar_chart_rounded),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              key: UniqueKey(),
                            )));
              },
            ),
          ),
        ],
      ),
    ),
  );
}
