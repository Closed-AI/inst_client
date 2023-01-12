import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inst_client/domain/repository/api_repository.dart';
import 'package:inst_client/ui/widgets/common/user_list_view_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/comment.dart';
import '../../../domain/models/user.dart';
import '../../../internal/config/app_config.dart';
import '../../../internal/dependencies/repository_module.dart';
import 'comment_list_view_model.dart';

class CommentListWidget extends StatelessWidget {
  CommentListWidget({super.key});

  ApiRepository _api = RepositoryModule.apiRepository();
  User? user;

  Future waitUser(String userId) async {
    user = await _api.getUserById(userId).then((value) => user = value);
  }

  List<Widget> _createCommentWidgetList(List<Comment> comments) {
    return List.generate(comments.length, (i) {
      waitUser(comments[i].authorId);
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {}, // TODO: go to user profile
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: (user != null && user!.avatarLink != null)
                        ? NetworkImage(
                            "$baseUrl${user!.avatarLink}",
                          )
                        : Image.asset("assets/images/blank_avatar.png").image,
                  ),
                ),
                Column(
                  children: [
                    if (user != null) Text(user!.name),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          comments[i].text,
                          maxLines: 10,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CommentListViewModel>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: viewModel.commentTec,
                    decoration:
                        const InputDecoration(hintText: "Write comment"),
                  ),
                ),
                Column(
                  children: (viewModel.comments != null)
                      ? _createCommentWidgetList(viewModel.comments!)
                      : <Widget>[],
                )
              ],
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(50, 50),
                  shape: const CircleBorder(),
                ),
                onPressed: (viewModel.commentTec.text.isNotEmpty)
                    ? () =>
                        viewModel.writeComment() // exit to home and update ui
                    : () {},
                child: const Icon(Icons.send_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static create(Object? arg) {
    String postId = "";
    if (arg != null && arg is String) postId = arg;

    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          CommentListViewModel(context: context, postId: postId),
      child: CommentListWidget(),
    );
  }
}
