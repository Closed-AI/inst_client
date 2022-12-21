import 'package:inst_client/ui/roots/app.dart';
import 'package:inst_client/ui/roots/auth.dart';
import 'package:inst_client/ui/roots/loader.dart';
import 'package:inst_client/ui/profile/profile.dart';
import 'package:flutter/material.dart';

class NavigationRoutes {
  static const loaderWidget = "/";
  static const auth = "/auth";
  static const app = "/app";
  static const profile = "/app/profile";
  static const create = "/auth/create";
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static Future toLoader() async {
    return await key.currentState?.pushNamedAndRemoveUntil(
        NavigationRoutes.loaderWidget, ((route) => false));
  }

  static Future toAuth() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.auth, ((route) => false));
  }

  static Future toProfile() async {
    return await key.currentState?.pushNamed(NavigationRoutes.profile);
  }

  static Future toHome() async {
    return await key.currentState
        ?.pushNamedAndRemoveUntil(NavigationRoutes.app, ((route) => false));
  }

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings, context) {
    switch (settings.name) {
      case NavigationRoutes.loaderWidget:
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoaderWidget.create());
      case NavigationRoutes.auth:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => Auth.create());
      case NavigationRoutes.app:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => App.create());
    }
    return null;
  }
}
