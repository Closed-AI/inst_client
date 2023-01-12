import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inst_client/domain/models/attach_meta.dart';
import 'package:inst_client/ui/navigation/app_navigator.dart';
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
  var images = <Widget>[];

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
        var widget = Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Image(
                  fit: BoxFit.cover,
                  image: Image.file(File(_imagePath!)).image,
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );

        attaches.add(t.first);
        images.add(widget);
      }
    }
    notifyListeners();
  }

  void deletePhoto() {}

  Future createPost() async {
    _api.createPost(
      CreatePostModel(
        authorId: _user!.id,
        description: descriptionTec.text,
        contents: attaches,
      ),
    );

    AppNavigator.toHome();

    attaches = <AttachMeta>[];
    images = <Widget>[];

    descriptionTec.text = "";
    notifyListeners();
  }
}
