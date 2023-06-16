import 'package:flutter/material.dart';
import 'package:langdida_ui/src/api_models/card.dart';

class CardExpansionPanelList extends StatefulWidget {
  final CardModel _card;
  final Function(CardModel newResponse) onValueChanged;
  List<String>? _searchedExplanations;
  CardExpansionPanelList(this._card, this.onValueChanged,
      {super.key, List<String>? searchedExplanations})
      : _searchedExplanations = searchedExplanations;

  @override
  State<CardExpansionPanelList> createState() => _CardExpansionPanelListState();
}

class _CardExpansionPanelListState extends State<CardExpansionPanelList> {
  List<TextEditingController> explanationsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> sentencesControllers = [TextEditingController()];
  List<TextEditingController> labelsControllers = [TextEditingController()];
  final List<bool> _isExpandedList = List.filled(4, false);

  @override
  void setState(VoidCallback fn) {
    widget._card.explanations.addAll(widget._searchedExplanations ?? []);
    explanationsControllers.addAll(widget._searchedExplanations
            ?.map((e) => TextEditingController(text: e)) ??
        []);
    widget._searchedExplanations = null;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    explanationsControllers = widget._card.explanations
        .map((e) => TextEditingController(text: e))
        .toList();
    sentencesControllers = widget._card.exampleSentences
        .map((e) => TextEditingController(text: e))
        .toList();
    labelsControllers =
        widget._card.labels.map((e) => TextEditingController(text: e)).toList();
  }

  void addExplanation() {
    const initialContent = "new explanation";
    widget._card.explanations.add(initialContent);
    explanationsControllers.add(TextEditingController(text: initialContent));
    setState(() {});
  }

  void removeExplanation(int index) {
    widget._card.explanations.removeAt(index);
    explanationsControllers.removeAt(index);
    setState(() {});
  }

  void addSentence() {
    const initialContent = "new sentence";
    widget._card.exampleSentences.add(initialContent);
    sentencesControllers.add(TextEditingController(text: initialContent));
    setState(() {});
  }

  void removeSentence(int index) {
    widget._card.exampleSentences.removeAt(index);
    sentencesControllers.removeAt(index);
    setState(() {});
  }

  void addLabel() {
    const initialContent = "new label";
    widget._card.labels.add(initialContent);
    labelsControllers.add(TextEditingController(text: initialContent));
    setState(() {});
  }

  void removeLabel(int index) {
    widget._card.labels.removeAt(index);
    labelsControllers.removeAt(index);
    setState(() {});
  }

  Widget appendTextFieldButton(void Function()? onPressed) {
    return SizedBox(
      height: 25,
      width: 25,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      key: UniqueKey(),
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpandedList[panelIndex] = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text("Index")),
          body: Column(
            children: [
              Text("word: ${widget._card.index.name}"),
              Text("language: ${widget._card.index.language}"),
            ],
          ),
          isExpanded: _isExpandedList[0],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text("labels"));
          },
          body: Column(
            children: [
              for (int i = 0; i < labelsControllers.length; i++)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: labelsControllers[i],
                        onChanged: (value) {
                          widget._card.labels[i] = value;
                          widget.onValueChanged(widget._card);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () => removeLabel(i),
                        iconSize: 20,
                        icon: const Icon(Icons.delete))
                  ],
                ),
              appendTextFieldButton(addLabel),
            ],
          ),
          isExpanded: _isExpandedList[1],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text("explanations"));
          },
          body: Column(
            children: [
              for (int i = 0; i < explanationsControllers.length; i++)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: explanationsControllers[i],
                        onChanged: (value) {
                          widget._card.explanations[i] = value;
                          widget.onValueChanged(widget._card);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () => removeExplanation(i),
                        iconSize: 20,
                        icon: const Icon(Icons.delete))
                  ],
                ),
              appendTextFieldButton(addExplanation),
            ],
          ),
          isExpanded: _isExpandedList[2],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text("example sentences"));
          },
          body: Column(
            children: [
              for (int i = 0; i < sentencesControllers.length; i++)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: sentencesControllers[i],
                        onChanged: (value) {
                          widget._card.exampleSentences[i] = value;
                          widget.onValueChanged(widget._card);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () => removeSentence(i),
                        iconSize: 20,
                        icon: const Icon(Icons.delete))
                  ],
                ),
              appendTextFieldButton(addSentence),
            ],
          ),
          isExpanded: _isExpandedList[3],
        )
      ],
    );
  }
}
