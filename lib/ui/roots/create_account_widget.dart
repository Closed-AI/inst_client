import 'package:inst_client/data/services/auth_service.dart';
import 'package:inst_client/domain/models/create_user.dart';
import 'package:inst_client/internal/dependencies/repository_module.dart';
import 'package:inst_client/ui/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String name;
  final String email;
  final String password;
  final String retryPassword;
  final DateTime birthDate;

  final bool isLoading;
  final String? errorText;

  const _ViewModelState({
    this.name = "",
    this.email = "",
    this.password = "",
    this.retryPassword = "",
    birthDate,
    this.isLoading = false,
    this.errorText,
  }) : this.birthDate = birthDate;

  _ViewModelState copyWith({
    String? name,
    String? email,
    String? password,
    String? retryPassword,
    DateTime? birthDate,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      retryPassword: retryPassword ?? this.retryPassword,
      birthDate: birthDate ?? this.birthDate,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var nameTec = TextEditingController();
  var emailTec = TextEditingController();
  var passwordTec = TextEditingController();
  var retryPasswordTec = TextEditingController();
  var birthDateTec = TextEditingController();

  final _authService = AuthService();
  final _api = RepositoryModule.apiRepository();

  BuildContext context;

  var _state = _ViewModelState(birthDate: DateTime.now());

  _ViewModel({required this.context}) {
    nameTec.addListener(() {
      state = state.copyWith(name: nameTec.text);
    });
    emailTec.addListener(() {
      state = state.copyWith(email: emailTec.text);
    });
    passwordTec.addListener(() {
      state = state.copyWith(password: passwordTec.text);
    });
    retryPasswordTec.addListener(() {
      state = state.copyWith(retryPassword: retryPasswordTec.text);
    });
    birthDateTec.addListener(() {
      state = state.copyWith(birthDate: DateTime.parse(birthDateTec.text));
    });
  }

  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return state.name.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.retryPassword.isNotEmpty &&
        state.birthDate.toString().isNotEmpty;
  }

  void create() async {
    state = state.copyWith(isLoading: true);

    try {
      await _api.createUser(
        CreateUser(
          name: state.name,
          email: state.email,
          password: state.password,
          retryPassword: state.retryPassword,
          birthDate: DateTime.parse("2022-12-21T08:45:03.371Z"),
        ),
      );
      AppNavigator.toLoader()
          .then((value) => {state = state.copyWith(isLoading: false)});
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on ServerException {
      state = state.copyWith(errorText: "произошла ошибка на сервере");
    }
  }
}

class CreateAccountWidget extends StatelessWidget {
  const CreateAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create account"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: viewModel.nameTec,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextField(
                  controller: viewModel.emailTec,
                  decoration: const InputDecoration(hintText: "email"),
                ),
                TextField(
                  controller: viewModel.passwordTec,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "password"),
                ),
                TextField(
                  controller: viewModel.retryPasswordTec,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "retry password"),
                ),
                InputDatePickerFormField(
                    firstDate: DateTime(1900), lastDate: DateTime.now()),
                ElevatedButton(
                  onPressed: () => viewModel.create(),
                  child: const Text("Create"),
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

  static create(BuildContext bc) {
    return ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const CreateAccountWidget(),
    );
  }
}
