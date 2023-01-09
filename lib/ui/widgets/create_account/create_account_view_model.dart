import 'package:inst_client/data/services/auth_service.dart';
import 'package:inst_client/domain/models/create_user.dart';
import 'package:inst_client/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

class _ViewModelState {
  final String name;
  final String email;
  final String password;
  final String retryPassword;
  final DateTime? birthDate;

  final bool isLoading;
  final String? errorText;

  _ViewModelState({
    this.name = "",
    this.email = "",
    this.password = "",
    this.retryPassword = "",
    this.birthDate,
    this.isLoading = false,
    this.errorText,
  });

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

class CreateAccountViewModel extends ChangeNotifier {
  var nameTec = TextEditingController();
  var emailTec = TextEditingController();
  var passwordTec = TextEditingController();
  var retryPasswordTec = TextEditingController();
  var birthDateTec = TextEditingController();

  final _authService = AuthService();

  BuildContext context;

  var _state = _ViewModelState();

  CreateAccountViewModel({required this.context}) {
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
      state = state.copyWith(
        birthDate: DateTime.tryParse(_reverseDateTime(birthDateTec.text)),
      );
    });
  }

  String _reverseDateTime(String input) {
    var chars = input.split('/');
    return chars.reversed.join();
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
        state.birthDate != null &&
        state.birthDate.toString().isNotEmpty;
  }

  void create() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService
          .createUser(
        CreateUser(
          name: state.name,
          email: state.email,
          password: state.password,
          retryPassword: state.retryPassword,
          birthDate: state.birthDate!,
        ),
      )
          .then((value) {
        AppNavigator.toLoader()
            .then((value) => {state = state.copyWith(isLoading: false)});
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on WrongCredentionalException {
      state = state.copyWith(errorText: "пароли должны совпадать!");
    } on ServerException {
      state =
          state.copyWith(errorText: "пользователь с таким логином существует");
    }
  }
}
