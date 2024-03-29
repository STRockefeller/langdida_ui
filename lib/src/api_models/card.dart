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
      index: CardIndex.fromJson(json["index"]),
      labels: List<String>.from(json["labels"]),
      explanations: List<String>.from(json["explanations"]),
      exampleSentences: List<String>.from(json["example_sentences"]),
      familiarity: json["familiarity"] ?? 0,
      reviewDate: json["review_date"],
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
      "index": index.toJson(),
      "labels": labels,
      "explanations": explanations,
      "example_sentences": exampleSentences,
      "familiarity": familiarity,
      "review_date": reviewDate,
    };
  }
}

class CardIndex {
  String name;
  String language;

  CardIndex({required this.name, required this.language});

  factory CardIndex.fromJson(Map<String, dynamic> json) {
    return CardIndex(
      name: json["name"],
      language: json.containsKey("language") ? json["language"] : "en",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "language": language,
    };
  }
}

class CardAssociations {
  CardIndex index;
  List<CardIndex> synonyms;
  List<CardIndex> antonyms;
  CardIndex origin;
  List<CardIndex> derivatives;
  List<CardIndex> inOtherLanguages;
  List<CardIndex> others;

  CardAssociations({
    required this.index,
    required this.synonyms,
    required this.antonyms,
    required this.origin,
    required this.derivatives,
    required this.inOtherLanguages,
    required this.others,
  });

  factory CardAssociations.fromJson(Map<String, dynamic> json) {
    List<CardIndex> parseJsonIndices(String key) => json[key] == null
        ? []
        : List<CardIndex>.from(json[key].map((x) => CardIndex.fromJson(x)));
    return CardAssociations(
      index: CardIndex.fromJson(json["index"]),
      synonyms: parseJsonIndices("synonyms"),
      antonyms: parseJsonIndices("antonyms"),
      origin: CardIndex.fromJson(json["origin"]),
      derivatives: parseJsonIndices("derivatives"),
      inOtherLanguages: parseJsonIndices("inOtherLanguages"),
      others: parseJsonIndices("others"),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["index"] = index.toJson();
    data["synonyms"] = synonyms.map((x) => x.toJson()).toList();
    data["antonyms"] = antonyms.map((x) => x.toJson()).toList();
    data["origin"] = origin.toJson();
    data["derivatives"] = derivatives.map((x) => x.toJson()).toList();
    data["inOtherLanguages"] = inOtherLanguages.map((x) => x.toJson()).toList();
    data["others"] = others.map((x) => x.toJson()).toList();
    return data;
  }
}

enum AssociationTypes {
  synonyms,
  antonyms,
  origin,
  derivatives,
  inOtherLanguages,
  others,
}

extension AssociationTypesExtension on AssociationTypes {
  String get stringValue {
    switch (this) {
      case AssociationTypes.origin:
        return "Origin";
      case AssociationTypes.derivatives:
        return "Derivatives";
      case AssociationTypes.synonyms:
        return "Synonyms";
      case AssociationTypes.antonyms:
        return "Antonyms";
      case AssociationTypes.inOtherLanguages:
        return "In Other Languages";
      case AssociationTypes.others:
        return "Others";
    }
  }
}

extension StringExtension on String {
  AssociationTypes? get associationType {
    switch (this) {
      case "Origin":
        return AssociationTypes.origin;
      case "Derivatives":
        return AssociationTypes.derivatives;
      case "Synonyms":
        return AssociationTypes.synonyms;
      case "Antonyms":
        return AssociationTypes.antonyms;
      case "In Other Languages":
        return AssociationTypes.inOtherLanguages;
      case "Others":
        return AssociationTypes.others;
      default:
        return null;
    }
  }
}

class CreateAssociationConditions {
  CardIndex cardIndex;
  CardIndex relatedCardIndex;
  AssociationTypes association;

  CreateAssociationConditions({
    required this.cardIndex,
    required this.relatedCardIndex,
    required this.association,
  });

  Map<String, dynamic> toJson() => {
        "CardIndex": cardIndex.toJson(),
        "RelatedCardIndex": relatedCardIndex.toJson(),
        "Association": association.index,
      };
}
