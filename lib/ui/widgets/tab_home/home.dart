import 'package:inst_client/ui/navigation/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/services/data_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../domain/models/post_model.dart';
import '../../../internal/config/app_config.dart';
import '../../../internal/dependencies/repository_module.dart';
import '../roots/app.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();
  final _lvc = ScrollController();

  bool _changed = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  _ViewModel({required this.context}) {
    asyncInit();
    _lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = (current / max * 100);
      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            posts = <PostModel>[...posts!, ...posts!];
            isLoading = false;
          });
        }
      }
    });
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void asyncInit() async {
    await SyncService().syncPosts();
    posts = await _dataService.getPosts();
  }

  void likePost(String postId) {
    _api.likePost(postId);

    notifyListeners();
  }

  void toPostComments(String postId) async {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.comments, arguments: postId);
  }

  void toPostDetail(PostModel post) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: post);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appmodel = context.read<AppViewModel>();
    var viewModel = context.watch<_ViewModel>();
    var size = MediaQuery.of(context).size;
    var itemCount = viewModel.posts?.length ?? 0;

    return SafeArea(
      child: Container(
        child: viewModel.posts == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: viewModel._lvc,
                      itemBuilder: (_, listIndex) {
                        Widget res;
                        var posts = viewModel.posts;
                        if (posts != null) {
                          var post = posts[listIndex];
                          res = Column(
                            children: [
                              GestureDetector(
                                onTap: () => viewModel.toPostDetail(post),
                                child: Container(
                                  height: size.width + 130,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: GestureDetector(
                                              onTap:
                                                  () {}, // TODO: go to user profile
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: (post.author
                                                              .avatarLink !=
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
                                          onPageChanged: (value) => viewModel
                                              .onPageChanged(listIndex, value),
                                          itemCount: post.contents.length,
                                          itemBuilder: (_, pageIndex) =>
                                              Container(
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
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
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
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                          );
                        } else {
                          res = const SizedBox.shrink();
                        }
                        return res;
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: itemCount,
                    ),
                  ),
                  if (viewModel.isLoading) const LinearProgressIndicator()
                ],
              ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Home(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Icon(
          Icons.circle,
          size: i == (current ?? 0) ? width * 1.4 : width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    );
  }
}
