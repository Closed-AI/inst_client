import 'package:inst_client/ui/widgets/create_account/create_account_view_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateAccountWidget extends StatelessWidget {
  const CreateAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreateAccountViewModel>();

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
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextField(
                  controller: viewModel.passwordTec,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                TextField(
                  controller: viewModel.retryPasswordTec,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Retry password"),
                ),
                TextField(
                  controller: viewModel.birthDateTec,
                  decoration: const InputDecoration(
                    labelText: "Enter Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1901),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      viewModel.birthDateTec.text = formattedDate;
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: viewModel.checkFields()
                      ? () {
                          _dialogBuilder(context)
                              .then((value) => viewModel.create());
                        }
                      : null,
                  child: const Text("Login"),
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
    return ChangeNotifierProvider<CreateAccountViewModel>(
      create: (context) => CreateAccountViewModel(context: context),
      child: const CreateAccountWidget(),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(""),
          content: const Text("Пользователь успешно зарегистрирован!"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
