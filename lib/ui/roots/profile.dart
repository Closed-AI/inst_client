import 'package:flutter/material.dart';
import 'package:inst_client/data/services/auth_service.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:inst_client/internal/config/app_config.dart';
import 'package:inst_client/internal/config/shared_prefs.dart';
import 'package:inst_client/internal/config/token_storage.dart';
import 'package:provider/provider.dart';

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
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_sharp),
            onPressed: () {},
            // TODO: add settings
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          children: [
            CircleAvatar(
              backgroundImage:
                  (viewModel.user != null && viewModel.headers != null)
                      ? NetworkImage(
                          "$baseUrl${viewModel.user!.avatarLink}",
                          headers: viewModel.headers,
                        )
                      : null,
              radius: 120,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              (viewModel.user != null && viewModel.headers != null)
                  ? viewModel.user!.name
                  : "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(),
            // TODO: add posts
          ],
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Profile(),
    );
  }
}
