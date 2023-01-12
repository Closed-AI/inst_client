import 'package:inst_client/domain/enums/tab_item.dart';
import 'package:inst_client/ui/widgets/common/user_list.dart';
import 'package:inst_client/ui/widgets/tab_create_post/create_post_widget.dart';
import 'package:inst_client/ui/widgets/tab_home/post_detail.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/app/';
  static const String postDetails = "/app/postDetails";
  static const String createPost = "/app/createPost";
  static const String users = "/app/users";
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItemEnum tabItem;
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
  }) : super(key: key);

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
          {Object? arg}) =>
      {
        TabNavigatorRoutes.root: (context) =>
            TabEnums.tabRoots[tabItem] ??
            SafeArea(
              child: Text(tabItem.name),
            ),
        TabNavigatorRoutes.postDetails: (context) => PostDetail.create(arg),
        TabNavigatorRoutes.createPost: (context) => CreatePostWidget.create(),
        TabNavigatorRoutes.users: (context) => UserListWidget.create(arg),
      };

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (settings) {
        var rb = _routeBuilders(context, arg: settings.arguments);
        if (rb.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: (context) => rb[settings.name]!(context),
          );
        }

        return null;
      },
    );
  }
}
