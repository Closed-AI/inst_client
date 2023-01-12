import 'dart:io';

import 'package:inst_client/internal/config/app_config.dart';
import 'package:inst_client/internal/dependencies/repository_module.dart';
import 'package:inst_client/ui/widgets/common/cam_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inst_client/ui/widgets/roots/app.dart';
import 'package:provider/provider.dart';

import '../../../data/services/sync_service.dart';
import '../../../domain/models/post_model.dart';
import '../../../domain/models/user.dart';
import '../../../internal/config/shared_prefs.dart';
import '../../navigation/tab_navigator.dart';

class ProfileViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();

  final BuildContext context;

  ProfileViewModel({required this.context}) {
    asyncInit();
    var appmodel = context.read<AppViewModel>();
    appmodel.addListener(() {
      avatar = appmodel.avatar;
    });
  }
  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  List<User>? _subscribtions;
  List<User>? get subscribtions => _subscribtions;
  set subscribtions(List<User>? val) {
    _subscribtions = val;
    notifyListeners();
  }

  List<User>? _subscribers;
  List<User>? get subscribers => _subscribers;
  set subscribers(List<User>? val) {
    _subscribers = val;
    notifyListeners();
  }

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    subscribtions = await _api.getSubscribtions(user!.id);
    subscribers = await _api.getSubscribers(user!.id);
    await SyncService().syncPosts();

    if (user != null) posts = await _api.getUserPosts(user!.id, 0, 100);
  }

  String? _imagePath;
  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  Future changePhoto() async {
    var appmodel = context.read<AppViewModel>();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: CamWidget(
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      avatar = null;
      var t = await _api.uploadTemp(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        await _api.addAvatarToUser(t.first);

        var img = (user?.avatarLink != null)
            ? await NetworkAssetBundle(Uri.parse("$baseUrl${user?.avatarLink}"))
                .load("$baseUrl${user!.avatarLink}?v=1")
            : File(_imagePath!).readAsBytesSync();
        var avImage = Image.memory(img.buffer.asUint8List());

        appmodel.avatar = avImage;
      }
    }
  }

  void toUserList(List<User>? users) {
    Navigator.of(context).pushNamed(TabNavigatorRoutes.users, arguments: users);
  }
}
