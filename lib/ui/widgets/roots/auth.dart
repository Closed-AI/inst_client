import 'package:inst_client/data/services/auth_service.dart';
import 'package:inst_client/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:inst_client/ui/widgets/create_account/create_account_widget.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  final String? errorText;

  const _ViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();

  final _authService = AuthService();

  BuildContext context;

  var _state = const _ViewModelState();

  _ViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
  }

  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false);
  }

  void login() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.auth(state.login, state.password).then((value) {
        AppNavigator.toLoader()
            .then((value) => {state = state.copyWith(isLoading: false)});
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on ServerException {
      state = state.copyWith(errorText: "не правильный логин или пароль");
    }
  }

  void toCreateAccount(BuildContext bc) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (__) => CreateAccountWidget.create(bc)));
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: viewModel.loginTec,
                  decoration: const InputDecoration(hintText: "Enter Login"),
                ),
                TextField(
                  controller: viewModel.passwTec,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Enter Password"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          viewModel.checkFields() ? viewModel.login : null,
                      child: const Text("Login"),
                    ),
                    const Text(
                      "or",
                      style: TextStyle(color: Colors.grey),
                    ),
                    ElevatedButton(
                      onPressed: () => viewModel.toCreateAccount(context),
                      child: const Text("Create account"),
                    ),
                  ],
                ),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Auth(),
      );
}
