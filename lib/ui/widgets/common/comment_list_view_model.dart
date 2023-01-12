import 'package:flutter/cupertino.dart';
import 'package:inst_client/ui/navigation/app_navigator.dart';

import '../../../domain/models/comment.dart';
import '../../../internal/dependencies/repository_module.dart';

class CommentListViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();

  var commentTec = TextEditingController();

  final BuildContext context;

  String postId;

  CommentListViewModel({required this.context, required this.postId}) {
    if (postId != "")
      _api.getPostComments(postId).then(
            (value) => comments = value,
          );
  }

  void writeComment() {
    if (postId != "") _api.writeComment(postId, commentTec.text);
    notifyListeners();

    AppNavigator.toHome();
  }

  List<Comment>? _comments;
  List<Comment>? get comments => _comments;
  set comments(List<Comment>? val) {
    _comments = val;
    notifyListeners();
  }
}
