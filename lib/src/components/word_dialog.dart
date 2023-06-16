import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/components/flash_message.dart';
import 'package:langdida_ui/src/features/book/card_expand_panel_list.dart';
import 'package:langdida_ui/src/utils/connections.dart';
import 'package:intl/intl.dart';

class WordDialog extends StatefulWidget {
  final String _word;
  final String _lang;
  const WordDialog(this._word, this._lang, {super.key});

  @override
  State<WordDialog> createState() => _WordDialogState();
}

class _WordDialogState extends State<WordDialog> {
  Widget _content = const ExpansionPanelList();
  late CardModel _card;
  TextButton _upsertButton =
      TextButton(onPressed: () {}, child: const Text("Loading"));

  void _getCard() async {
    try {
      _card = await Connections.getCard(widget._word, widget._lang);
      _upsertButton = TextButton(
        child: const Text("Edit Card"),
        onPressed: () {
          Connections.editCard(_card).then((value) {
            showFlashMessage(context, "Complete");
            Navigator.of(context).pop();
          }).catchError((error) {
            showFlashMessage(context, error.toString());
          });
        },
      );
    } catch (e) {
      showFlashMessage(context, e.toString());
      _upsertButton = TextButton(
        child: const Text("Create Card"),
        onPressed: () {
          _card.familiarity = 0;
          _card.reviewDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          Connections.createCard(_card).then((value) {
            showFlashMessage(context, "Complete");
            Navigator.of(context).pop();
          }).catchError((error) {
            showFlashMessage(context, error.toString());
          });
        },
      );
    } finally {
      setState(
          () => _content = CardExpansionPanelList(_card, (CardModel newResp) {
                _card = newResp;
              }));
    }
  }

  @override
  void initState() {
    super.initState();
    _card = CardModel(
      index: CardIndex(name: widget._word, language: widget._lang),
      labels: [],
      explanations: [],
      exampleSentences: [],
      familiarity: 0,
      reviewDate: "",
    );
    _getCard();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: Text(widget._word),
          insetPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: [
                _content,
              ],
            ),
          ),
          actions: [
            _upsertButton,
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: Tooltip(
            message: "get the meanings of the vocabulary from dictionaries",
            child: FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () {
                Connections.searchMeanings(widget._lang, widget._word)
                    .then((value) {
                  setState(() {
                    _content = CardExpansionPanelList(
                      _card,
                      (CardModel newResp) {
                        _card = newResp;
                      },
                      searchedExplanations: value,
                    );
                  });
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
