import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inst_client/ui/widgets/common/user_list_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/user.dart';
import '../../../internal/config/app_config.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({super.key});

  List<Widget> _createUserWidgetList(List<User> users) {
    return List.generate(
      users.length,
      (i) => Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (users[i].avatarLink != null)
                        ? NetworkImage(
                            "$baseUrl${users[i].avatarLink}",
                          )
                        : Image.asset("assets/images/blank_avatar.png").image,
                  ),
                ),
              ),
              Text(users[i].name)
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<UserListViewModel>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: (viewModel.users != null)
              ? _createUserWidgetList(viewModel.users!)
              : [],
        ),
      ),
    );
  }

  static create(Object? arg) {
    List<User>? users;
    if (arg != null && arg is List<User>?) users = arg as List<User>?;

    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          UserListViewModel(context: context, users: users),
      child: const UserListWidget(),
    );
  }
}
