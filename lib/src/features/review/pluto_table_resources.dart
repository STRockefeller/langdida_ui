import 'package:langdida_ui/src/api_models/card.dart';
import 'package:pluto_grid/pluto_grid.dart';

class _PlutoColumnFields {
  static const name = "name";
  static const language = "language";
  static const familiarity = "familiarity";
  static const reviewDate = "review_date";
}

class PlutoGridTable {
  static final List<PlutoColumn> columns = [
    PlutoColumn(
        title: "Name",
        field: _PlutoColumnFields.name,
        type: PlutoColumnType.text()),
    PlutoColumn(
        title: "Language",
        field: _PlutoColumnFields.language,
        type: PlutoColumnType.text()),
    PlutoColumn(
        title: "Familiarity",
        field: _PlutoColumnFields.familiarity,
        type: PlutoColumnType.number()),
    PlutoColumn(
        title: "Review Date",
        field: _PlutoColumnFields.reviewDate,
        type: PlutoColumnType.text()),
  ];

  static List<PlutoRow> newRows(List<CardModel> cards) {
    return cards
        .map((e) => PlutoRow(cells: {
              _PlutoColumnFields.name: PlutoCell(value: e.index.name),
              _PlutoColumnFields.language: PlutoCell(value: e.index.language),
              _PlutoColumnFields.familiarity: PlutoCell(value: e.familiarity),
              _PlutoColumnFields.reviewDate: PlutoCell(value: e.reviewDate),
            }))
        .toList();
  }
}
