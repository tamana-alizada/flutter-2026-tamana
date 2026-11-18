import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  factory ApiClient.createDefault() => ApiClient(http.Client());
  final http.Client _client;
  final String host;

  Map<String, String> get headers => const {'Accept': 'application/json'};

  Future<http.Response> get(Uri uri) =>
      _send(() => _client.get(uri, headers: headers));

  Future<http.Response> post(Uri uri, {required String body}) => _send(
        () => _client.post(uri,
            headers: {
              ...headers,
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body),
      );

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final r = await call().timeout(const Duration(seconds: 10));
      if (kDebugMode) {
        developer.log(
            '${r.request?.method} ${r.request?.url.path} → ${r.statusCode}',
            name: 'api');
      }
      return r;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    }
  }

  void check(http.Response r) {
    if (r.statusCode == 401) throw const UnauthorizedException();
    if (r.statusCode == 404) throw const NotFoundException();
    if (r.statusCode >= 500) throw ServerException(r.statusCode);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw BadResponseException('Unexpected HTTP status ${r.statusCode}');
    }
  }

  dynamic decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException(e.message);
    }
  }
}
