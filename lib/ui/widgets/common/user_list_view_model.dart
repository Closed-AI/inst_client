import 'package:flutter/cupertino.dart';

import '../../../domain/models/user.dart';
import '../../../internal/dependencies/repository_module.dart';

class UserListViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();

  final BuildContext context;

  UserListViewModel({required this.context, required List<User>? users}) {
    _users = users;
  }

  List<User>? _users;
  List<User>? get users => _users;
  set users(List<User>? val) {
    _users = val;
    notifyListeners();
  }
}
