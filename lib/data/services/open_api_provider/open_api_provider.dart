import 'package:dio/dio.dart';
import 'package:dio_example/data/models/top_level_data.dart';
import 'package:dio_example/data/services/open_api_provider/open_api_client.dart';
import 'package:flutter/material.dart';

class OpenApiProvider {
  final OpenApiClient openApiClient;

  OpenApiProvider({required this.openApiClient});

  Future<TopLevelData> fetchMemesData() async {
    try {
      final Response response = await openApiClient.dio
          .get("${openApiClient.dio.options.baseUrl}/get_memes");
      debugPrint('Memes:${response.statusCode}');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        TopLevelData topLevelData = TopLevelData.fromJson(response.data);
        return topLevelData;
      } else {
        throw Exception();
      }
    } on DioError catch (er) {
      print(er.response!.statusCode);
      throw Exception();
    }
  }
}
