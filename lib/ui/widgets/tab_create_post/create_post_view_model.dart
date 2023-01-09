import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user.dart';
import '../../../../internal/config/shared_prefs.dart';
import '../../../domain/models/create_post_model.dart';
import '../../../internal/dependencies/repository_module.dart';
import '../common/cam_widget.dart';
import '../roots/app.dart';

class CreatePostViewModel extends ChangeNotifier {
  var descriptionTec = TextEditingController();
  final _api = RepositoryModule.apiRepository();

  var attaches = <AttachMeta>[];
  var images = <Image>[];

  final BuildContext context;

  CreatePostViewModel({required this.context}) {
    descriptionTec.addListener(() {});
    asyncInit();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  String? _imagePath;

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
  }

  Future addPhoto() async {
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
      var t = await _api.uploadTemp(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        attaches.add(t.first);
        images.add(Image.file(File(_imagePath!)));
      }
    }
    notifyListeners();
  }

  Future createPost() async {
    _api.createPost(
      CreatePostModel(
        authorId: _user!.id,
        description: descriptionTec.text,
        contents: attaches,
      ),
    );
  }
}
