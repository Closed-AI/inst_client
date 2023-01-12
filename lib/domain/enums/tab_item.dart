import 'package:flutter/material.dart';
import 'package:inst_client/ui/widgets/tab_create_post/create_post_widget.dart';

import '../../ui/widgets/tab_home/home.dart';
import '../../ui/widgets/tab_profile/profile/my_profile.dart';

enum TabItemEnum { home, search, newPost, favorites, profile }

class TabEnums {
  static const TabItemEnum defTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.home_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.newPost: Icons.add_photo_alternate_rounded,
    TabItemEnum.favorites: Icons.favorite_outline,
    TabItemEnum.profile: Icons.person_outline,
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.home: Home.create(),
    TabItemEnum.newPost: CreatePostWidget.create(),
    TabItemEnum.profile: MyProfileWidget.create(),
  };
}
