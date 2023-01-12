import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'create_post_view_model.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreatePostViewModel>();

    var postContentWidgets = viewModel.images;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "New post",
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Stack(
              children: [
                Container(
                  child: ListView(
                    children: [
                      Column(children: postContentWidgets),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(50, 50),
                            shape: const CircleBorder(),
                          ),
                          onPressed: viewModel.addPhoto,
                          child: const Icon(Icons.add_a_photo_outlined),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 200,
                        color: const Color(0xffeeeeee),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 200.0,
                          ),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: SizedBox(
                                height: 190.0,
                                child: TextField(
                                  controller: viewModel.descriptionTec,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Description',
                                  ),
                                  maxLines: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Icon(Icons.cancel, color: Colors.white),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(50, 50),
                      shape: const CircleBorder(),
                    ),
                    onPressed: (viewModel.images.isNotEmpty)
                        ? viewModel.createPost
                        : () => _dialogBuilder(context),
                    child: const Icon(Icons.send_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) {
        return CreatePostViewModel(context: context);
      },
      child: const CreatePostWidget(),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ошибка создания поста"),
          content: const Text("Невозможно создать пост\nбез изображений!\n"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
