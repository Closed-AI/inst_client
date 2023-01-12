import 'package:flutter/material.dart';
import 'package:inst_client/ui/widgets/tab_home/post_detail_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/post.dart';
import '../../../domain/models/post_model.dart';
import 'home.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({Key? key}) : super(key: key);

  get baseUrl => null;

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<PostDetailViewModel>();
    var post = viewModel.post;
    var listIndex = 1;
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            GestureDetector(
              onTap: () => viewModel.toPostDetail(post.id),
              child: Container(
                height: MediaQuery.of(context).size.width + 130,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {}, // TODO: go to user profile
                            child: CircleAvatar(
                                radius: 20,
                                backgroundImage: (post!.author.avatarLink !=
                                        null)
                                    ? NetworkImage(
                                        "$baseUrl${post.author.avatarLink}")
                                    : Image.asset(
                                            "assets/images/blank_avatar.png")
                                        .image),
                          ),
                        ),
                        Text(post.author.name),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (value) =>
                            viewModel.onPageChanged(listIndex, value),
                        itemCount: post.contents.length,
                        itemBuilder: (_, pageIndex) => Container(
                          color: Colors.transparent,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "$baseUrl${post.contents[pageIndex].contentLink}",
                            ),
                          ),
                        ),
                      ),
                    ),
                    PageIndicator(
                      count: post.contents.length,
                      current: viewModel.pager[listIndex],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        post.description ?? "",
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      viewModel.likePost(post.id);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.favorite_border),
                        Text(post.likeCount.toString()),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.toPostComments(post.id);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline),
                        Text(post.commentCount.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  static create(Object? arg) {
    PostModel? _post;
    if (arg != null && arg is PostModel?) _post = arg as PostModel?;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          PostDetailViewModel(context: context, post: _post),
      child: const PostDetail(),
    );
  }
}
