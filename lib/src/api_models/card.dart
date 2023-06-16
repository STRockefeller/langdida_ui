class CardModel {
  CardIndex index;
  List<String> labels;
  List<String> explanations;
  List<String> exampleSentences;
  int familiarity;
  String reviewDate;

  CardModel({
    required this.index,
    required this.labels,
    required this.explanations,
    required this.exampleSentences,
    required this.familiarity,
    required this.reviewDate,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      index: CardIndex.fromJson(json['index']),
      labels: List<String>.from(json['labels']),
      explanations: List<String>.from(json['explanations']),
      exampleSentences: List<String>.from(json['example_sentences']),
      familiarity: json['familiarity'] ?? 0,
      reviewDate: json['review_date'],
    );
  }

  static List<CardModel> arrayFromJson(List<Map<String, dynamic>> json) {
    List<CardModel> cardModels = json.map((cardJson) {
      return CardModel.fromJson(cardJson);
    }).toList();

    return cardModels;
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index.toJson(),
      'labels': labels,
      'explanations': explanations,
      'example_sentences': exampleSentences,
      'familiarity': familiarity,
      'review_date': reviewDate,
    };
  }
}

class CardIndex {
  String name;
  String language;

  CardIndex({required this.name, required this.language});

  factory CardIndex.fromJson(Map<String, dynamic> json) {
    return CardIndex(
      name: json['name'],
      language: json.containsKey('language') ? json['language'] : 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'language': language,
    };
  }
}
