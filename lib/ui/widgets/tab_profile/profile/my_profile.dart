import 'package:inst_client/data/services/auth_service.dart';
import 'package:inst_client/data/services/data_service.dart';
import 'package:inst_client/domain/models/post.dart';
import 'package:inst_client/domain/models/user.dart';
import 'package:inst_client/internal/config/app_config.dart';
import 'package:inst_client/ui/widgets/common/profile_view_model.dart';
import 'package:inst_client/ui/widgets/common/user_list.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/post_model.dart';
import '../../../navigation/app_navigator.dart';

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  List<Padding> _buildGridTileList(int count, List<PostModel> elements) =>
      List.generate(
        count,
        (i) => Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            height: 10,
            width: 10,
            color: Colors.grey,
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                "$baseUrl${elements[i].contents[0].contentLink}",
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ProfileViewModel>();
    var size = MediaQuery.of(context).size;
    var userPosts = viewModel.posts;

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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: viewModel.user == null
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: Column(
                          children: [
                            viewModel.avatar == null
                                ? const Center(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: size.width / 1.5 / 2.5,
                                    backgroundImage: viewModel.avatar?.image,
                                  ),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Text(
                              (viewModel.user != null)
                                  ? viewModel.user!.name
                                  : "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: viewModel.changePhoto,
                              child: const Text("Изменить аватар"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: (viewModel.subscribtions != null)
                                        ? () {
                                            viewModel.toUserList(
                                                viewModel.subscribtions);
                                          }
                                        : () {},
                                    child: Column(
                                      children: [
                                        Text(
                                          (viewModel.subscribtions != null)
                                              ? viewModel.subscribtions!.length
                                                  .toString()
                                              : "0",
                                        ),
                                        const Text("Подписки"),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (viewModel.subscribers != null)
                                        ? () {
                                            viewModel.toUserList(
                                                viewModel.subscribers);
                                          }
                                        : () {},
                                    child: Column(
                                      children: [
                                        Text(
                                          (viewModel.subscribers != null)
                                              ? viewModel.subscribers!.length
                                                  .toString()
                                              : "0",
                                        ),
                                        const Text("Подписчики"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 3,
              children: (userPosts != null)
                  ? _buildGridTileList(
                      userPosts.length,
                      userPosts,
                    )
                  : [],
            ),
          ],
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(context: context);
      },
      child: const MyProfileWidget(),
    );
  }
}
