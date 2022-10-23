import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ones_blog/data/models/response.dart';

/// Thrown if an exception occurs while making an `http` request.
class HttpException implements Exception {}

/// {@template http_request_failure}
/// Thrown if an `http` request returns a non-200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  const HttpRequestFailure(this.statusCode);

  /// The status code of the response.
  final int statusCode;
}

/// Thrown when an error occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown when an error occurs while deserializing the response body.
class JsonDeserializationException implements Exception {}

/// {@template ones_blog_api}
/// A Dart API Client for the [OnesBlog REST API](https://onesblog.herokuapp.com/api/).
/// {@endtemplate}
class OnesBlogApiClient {
  /// {@macro ones_blog_api}
  OnesBlogApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'onesblog.herokuapp.com';
  static const _endpointPrefix = '/api/';
  final http.Client _httpClient;

  String _prefix(String uri) => _endpointPrefix + uri;

  Future<List<dynamic>> index({
    required String uri,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _get(Uri.https(_baseUrl, _prefix(uri), queryParams));

    try {
      return response.data as List;
    } catch (_) {
      throw JsonDeserializationException();
    }
  }

  Future<dynamic> store({
    required String uri,
    required Map<String, dynamic>? inputParams,
    String? token,
  }) async {
    final response = await _post(
      Uri.https(_baseUrl, _prefix(uri)),
      inputParams,
      token,
    );

    return response.data;
  }

  Future<Response> _get(Uri uri) async {
    http.Response response;

    try {
      response = await _httpClient.get(
        uri,
        headers: {
          HttpHeaders.acceptHeader: ContentType.json.toString(),
        },
      );
    } catch (_) {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    return _decodeResponseBody(response.body);
  }

  Future<Response> _post(
    Uri uri,
    Map<String, dynamic>? body,
    String? token,
  ) async {
    http.Response response;

    try {
      response = await _httpClient.post(
        uri,
        headers: {
          HttpHeaders.acceptHeader: ContentType.json.toString(),
          if (token != null) ...{
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }
        },
        body: body,
      );
    } catch (_) {
      throw HttpException();
    }

    if (![200, 201].contains(response.statusCode)) {
      throw HttpRequestFailure(response.statusCode);
    }

    return _decodeResponseBody(response.body);
  }

  Response _decodeResponseBody(String body) {
    try {
      return Response.fromJson(
        jsonDecode(body) as Map<String, dynamic>,
      );
    } catch (_) {
      throw JsonDecodeException();
    }
  }
}
