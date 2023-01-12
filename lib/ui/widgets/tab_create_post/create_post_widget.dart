import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'create_post_view_model.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<CreatePostViewModel>();

    var imageWidgets = viewModel.images;

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
                // Expanded(
                //   child: ListView(
                //     children: [
                //       // Container(
                //       //   height: 300,
                //       //   width: 300,
                //       //   child: Image.asset(
                //       //     "assets/images/blank_avatar.png",
                //       //     fit: BoxFit.cover,
                //       //   ),
                //       // ),
                //       // Positioned(
                //       //     top: 10,
                //       //     right: 10,
                //       //     child: ElevatedButton(
                //       //       onPressed: () {},
                //       //       style: const ButtonStyle(
                //       //         backgroundColor:
                //       //             MaterialStatePropertyAll<Color>(Colors.transparent),
                //       //       ),
                //       //       child: const Icon(Icons.close),
                //       Column(children: imageWidgets),
                //       const Divider(),
                //       Padding(
                //         padding: const EdgeInsets.only(bottom: 10),
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             fixedSize: const Size(50, 50),
                //             shape: const CircleBorder(),
                //           ),
                //           onPressed: () {
                //             viewModel.addPhoto();
                //           },
                //           child: const Icon(Icons.add_a_photo_outlined),
                //         ),
                //       ),

                //       Container(
                //         padding: const EdgeInsets.all(10),
                //         height: 200,
                //         color: const Color(0xffeeeeee),
                //         child: ConstrainedBox(
                //           constraints: const BoxConstraints(
                //             maxHeight: 200.0,
                //           ),
                //           child: Scrollbar(
                //             child: SingleChildScrollView(
                //               scrollDirection: Axis.vertical,
                //               reverse: true,
                //               child: SizedBox(
                //                 height: 190.0,
                //                 child: TextField(
                //                   controller: viewModel.descriptionTec,
                //                   decoration: const InputDecoration(
                //                     border: InputBorder.none,
                //                     hintText: 'Description',
                //                   ),
                //                   maxLines: 100,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Positioned(
                //   bottom: 10,
                //   right: 10,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       fixedSize: const Size(50, 50),
                //       shape: const CircleBorder(),
                //     ),
                //     onPressed: viewModel.createPost,
                //     child: const Icon(Icons.send_rounded),
                //   ),
                // ),
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
}
