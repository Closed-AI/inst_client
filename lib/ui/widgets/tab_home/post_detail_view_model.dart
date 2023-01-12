import 'package:flutter/cupertino.dart';

import '../../../data/services/data_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../domain/models/post_model.dart';
import '../../../internal/dependencies/repository_module.dart';
import '../../navigation/tab_navigator.dart';

class PostDetailViewModel extends ChangeNotifier {
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

  PostDetailViewModel({required this.context, required PostModel? post}) {
    asyncInit();
    _post = post;
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

  PostModel? _post;
  PostModel? get post => _post;
  set post(PostModel? val) {
    _post = val;
    notifyListeners();
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

  void toPostDetail(String postId) {
    Navigator.of(context)
        .pushNamed(TabNavigatorRoutes.postDetails, arguments: postId);
  }
}
