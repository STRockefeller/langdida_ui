import 'package:flutter/material.dart';
import 'package:langdida_ui/src/components/app_bar.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/components/word_dialog.dart';
import 'package:langdida_ui/src/features/review/pluto_table_resources.dart';
import 'package:langdida_ui/src/utils/connections.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<PlutoRow> rows = [];
  // ? I don't know why the onloaded event is not triggered when setState()
  Widget grid = const Text("Loading");

  @override
  void initState() {
    Connections.listCards().then((cards) {
      setState(() {
        rows = PlutoGridTable.newRows(cards);
        grid = _newPlutoGrid();
      });
    }).catchError((err) {
      showFlashMessage(context, err.toString());
    });
    super.initState();
  }

  Widget _newPlutoGrid() {
    return PlutoGrid(
      columns: PlutoGridTable.columns,
      rows: rows,
      mode: PlutoGridMode.select,
      onSelected: (event) {
        debugPrint(event.row?.cells.toString());
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return WordDialog(event.row?.cells["name"]?.value,
                  event.row?.cells["language"]?.value);
            });
      },
      configuration: const PlutoGridConfiguration(
        columnSize:
            PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.equal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newLangDiDaAppBar("Cards", context),
      body: Center(child: grid),
    );
  }
}
