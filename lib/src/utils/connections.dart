import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:langdida_ui/src/api_models/card.dart';
import 'package:langdida_ui/src/utils/errors.dart';

class Connections {
  static String _getServerAddress() {
    final GetStorage storage = GetStorage();
    String? serverAddress = storage.read('server_address');
    if (serverAddress?.isNotEmpty == true) {
      return serverAddress!;
    }
    return "";
  }

  static Future<bool> isConnected() async {
    Response response = await Dio().get("${_getServerAddress()}/ping");
    return response.statusCode == 200;
  }

  static Future<CardModel> getCard(String word, language) async {
    Response response = await Dio()
        .get("${_getServerAddress()}/card/get?word=$word&language=$language");
    if (response.statusCode != 200) {
      throw ApiException(
          response.statusCode ?? 0, response.statusMessage ?? "");
    }
    return CardModel.fromJson(response.data);
  }

  // throw exception while response status code is not 200
  static Future<void> createCard(CardModel card) async {
    Response response = await Dio()
        .post('${_getServerAddress()}/card/create', data: card.toJson());
    if (response.statusCode != 200) {
      throw ApiException(
          response.statusCode ?? 0, response.statusMessage ?? "");
    }
  }

  // throw exception while response status code is not 200
  static Future<void> editCard(CardModel card) async {
    Response response = await Dio()
        .put('${_getServerAddress()}/card/edit', data: card.toJson());
    if (response.statusCode != 200) {
      throw ApiException(
          response.statusCode ?? 0, response.statusMessage ?? "");
    }
  }

  static Future<List<String>> searchMeanings(
      String language, String word) async {
    try {
      final response = await Dio().get(
        '${_getServerAddress()}/card/dictionary/meanings',
        queryParameters: {
          'language': language,
          'word': word,
        },
      );

      if (response.statusCode == 200) {
        final meanings = List<String>.from(response.data);
        return meanings;
      } else {
        throw Exception('Failed to search meanings');
      }
    } catch (error) {
      throw Exception('Failed to connect to the API');
    }
  }

  static Future<List<CardModel>> listCards(
      [String? language, bool needReview = false, String? label]) async {
    try {
      Map<String, dynamic> queryParameters = <String, dynamic>{};
      if (language != null) {
        queryParameters['language'] = language;
      }
      if (needReview) {
        queryParameters['needReview'] = "true";
      }
      if (label != null) {
        queryParameters['label'] = label;
      }
      final response = await Dio().get(
        '${_getServerAddress()}/card/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final List<CardModel> cards =
            CardModel.arrayFromJson(_parseListCardsResponse(response.data));
        return cards;
      } else {
        throw Exception('Failed to search meanings');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  static List<Map<String, dynamic>> _parseListCardsResponse(dynamic data) {
    List<Map<String, dynamic>> res = [];
    (data as List<dynamic>).forEach((element) {
      res.add(element as Map<String, dynamic>);
    });
    return res;
  }

  static Future<List<CardIndex>> listCardIndexes() async {
    try {
      final response =
          await Dio().get('${_getServerAddress()}/card/index/list');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data).map((e) {
          return CardIndex(
              name: e["name"] ?? "", language: e["language"] ?? "");
        }).toList();
      } else {
        throw Exception('Failed to query the card indexes');
      }
    } catch (error) {
      throw Exception('Failed to connect to the API');
    }
  }
}
