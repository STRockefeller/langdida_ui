import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/features/graph_view/animation.dart';
import 'package:langdida_ui/src/utils/connections.dart';

class GraphViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GraphViewPageState();
}

class _GraphViewPageState extends State<GraphViewPage> {
  List<CardIndex> indexes = [];
  Widget _bodyWidget = const Text("Loading...");
  _GraphViewPageState() {
    Connections.listCardIndexes().then((value) {
      indexes = value;
      setState(() {
        _bodyWidget = AnimatedCanvas(cards: indexes);
      });
    }).catchError((error) {
      showFlashMessage(context, error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("relationships", context),
      body: _bodyWidget,
    );
  }
}
