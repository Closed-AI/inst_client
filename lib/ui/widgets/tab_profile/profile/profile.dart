import 'package:inst_client/data/services/auth_service.dart';
import 'package:inst_client/ui/widgets/tab_profile/profile/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../navigation/app_navigator.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dtf = DateFormat("dd.MM.yyyy HH:mm");
    var viewModel = context.watch<ProfileViewModel>();
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profile",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              AuthService().logout().then((value) => AppNavigator.toLoader());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: viewModel.user == null
              ? const CircularProgressIndicator()
              : ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  children: [
                    viewModel.avatar == null
                        ? const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : GestureDetector(
                            onTap: viewModel.changePhoto,
                            child: CircleAvatar(
                              radius: size.width / 1.5 / 2,
                              foregroundImage: viewModel.avatar?.image,
                            ),
                          ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      (viewModel.user != null) ? viewModel.user!.name : "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      dtf.format(viewModel.user!.birthDate),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Divider(),
                    // TODO: add posts
                  ],
                ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(context: context);
      },
      child: const ProfileWidget(),
    );
  }
}
