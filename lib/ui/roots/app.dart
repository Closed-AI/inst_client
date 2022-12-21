import 'package:inst_client/domain/models/user.dart';
import 'package:inst_client/internal/config/app_config.dart';
import 'package:inst_client/internal/config/shared_prefs.dart';
import 'package:inst_client/internal/config/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../app_navigator.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();

  _ViewModel({required this.context}) {
    asyncInit();
  }

  User? _user;

  User? get user => _user;

  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: (viewModel.user != null && viewModel.headers != null)
            ? GestureDetector(
                onTap: () => AppNavigator.toProfile(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "$baseUrl${viewModel.user!.avatarLink}",
                      headers: viewModel.headers,
                    ),
                  ),
                ),
              )
            : null,
        title: Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: viewModel._logout),
        ],
      ),
      body: Container(
        child: Column(children: []),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const App(),
    );
  }
}
