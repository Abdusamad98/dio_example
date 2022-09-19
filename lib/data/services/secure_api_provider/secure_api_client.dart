import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_example/data/local/storage.dart';
import 'package:dio_example/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class SecureApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 25000,
      receiveTimeout: 20000,
    ),
  );

  SecureApiClient() {
    _init();
    dio.interceptors.add(
      (InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            String myRefreshToken = StorageRepository.getString("refresh_token");
            if (myRefreshToken.isNotEmpty) {
              await refreshToken();
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
        onRequest: (requestOptions, handler) async {
          String accessToken = StorageRepository.getString("access_token");
          String currentLocale = StorageRepository.getString("current_locale");
          if (accessToken.isNotEmpty) {
            requestOptions.headers["Authorization"] = "Bearer $accessToken";
            requestOptions.headers["Accept-Language"] = currentLocale.isEmpty ? "ru" : currentLocale;
          }
          requestOptions.headers["Accept"] = "application/json";
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
      )),
    );
  }

  Future _init() async {
    await StorageRepository.getInstance();
  }

  Future<void> refreshToken() async {
    await StorageRepository.getInstance();
    final refreshToken = StorageRepository.getString("refresh_token");
    String oldAccessToken = StorageRepository.getString("access_token");
    try {
      final Response response = await dio.post("$BASE_URL/auth/refresh/",
          data: {"access_token": oldAccessToken, "refreshToken": refreshToken});

      if (response.statusCode == 201) {
        var responseJson = jsonDecode(response.data.toString());
        await StorageRepository.putString(
            'access_token', responseJson["access_token"]);
        await StorageRepository.putString(
            'refresh_token', responseJson["refresh_token"]);
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint('Refresh token dio Error: ${e.response!.data}');
      }
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
    Options(method: requestOptions.method, headers: requestOptions.headers);
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
