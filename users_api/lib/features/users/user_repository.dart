import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  UserRepository(this._api);
  final ApiClient _api;

  Future<List<User>> getAll() async {
    final http.Response r = await _api.get(Uri.https(_api.host, '/users'));
    _api.check(r);
    final data = _api.decode(r);
    if (data is! List<dynamic>) {
      throw const BadResponseException('Expected a JSON list from /users');
    }
    try {
      return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    final http.Response r = await _api.get(Uri.https(_api.host, '/users/$id'));
    _api.check(r);
    final data = _api.decode(r);
    try {
      return User.fromJson(data as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users/$id: $e');
    } on FormatException catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    final http.Response r = await _api.post(Uri.https(_api.host, '/users'),
        body: jsonEncode(draft.toJson()));
    _api.check(r);
    if (r.statusCode != 201) {
      throw BadResponseException('Expected 201, received ${r.statusCode}');
    }
    final data = _api.decode(r);
    try {
      return User.fromJson(data as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('POST users: $e');
    } on FormatException catch (e) {
      throw BadResponseException('POST users: $e');
    }
  }
}
