import 'package:inst_client/ui/navigation/app_navigator.dart';
import 'package:inst_client/ui/widgets/roots/loader.dart';
import 'package:flutter/material.dart';

import 'data/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your  application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstClone',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.key,
      onGenerateRoute: (settings) =>
          AppNavigator.onGeneratedRoutes(settings, context),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoaderWidget.create(),
    );
  }
}
