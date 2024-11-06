import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HTTPService {
  final Dio _dio = Dio();

  HTTPService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.cryptorank.io/v1/',
      queryParameters: {
        'api_key': dotenv.env['CRYPTO_RANK_API_KEY'],
      },
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (err) {
      developer.log('Fetch error: $err', name: 'FetchErrorLogger');
    }
  }
}
