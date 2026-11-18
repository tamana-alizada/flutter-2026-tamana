import 'package:flutter/foundation.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);
  final UserRepository _repo;
  List<User> items = const [];
  ApiException? error;
  bool loading = false;
  bool saving = false;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      items = await _repo.getAll();
    } on ApiException catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<User?> create(User draft) async {
    if (saving) return null;
    saving = true;
    notifyListeners();
    try {
      final user = await _repo.create(draft);
      items = [user, ...items];
      notifyListeners();
      return user;
    } on ApiException catch (e) {
      error = e;
      return null;
    } finally {
      saving = false;
      notifyListeners();
    }
  }
}
