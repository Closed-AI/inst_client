import 'dart:io';

import 'package:inst_client/ui/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../internal/config/app_config.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

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
            icon: const Icon(Icons.settings_sharp),
            onPressed: () {},
            // TODO: add settings
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
                        ? const CircularProgressIndicator()
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

  static create(BuildContext bc) {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(context: bc);
      },
      child: const Profile(),
    );
  }
}
