import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/auth/register/register_screen.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/my_theme_data.dart';
import 'package:todo_app/provider/app_config_provider.dart';
import 'package:todo_app/provider/app_theme_provider.dart';
import 'package:todo_app/provider/auth_user_provider.dart';
import 'package:todo_app/provider/list_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyCKmJ39fAt_6_jXH_S3Qj6bTOdw97ZUVw8',
              appId: 'com.example.todo_app',
              messagingSenderId: '587453560118',
              projectId: 'todo-app-cb5d2'))
      : await Firebase.initializeApp();
  //await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ListProvider()),
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
    ChangeNotifierProvider(
      create: (context) => AuthUserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AppThemeProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var providerTheme = Provider.of<AppThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      theme: MyThemeData.lightTheme,
      themeMode: providerTheme.appTheme,
      darkTheme: MyThemeData.darkMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
    );
  }
}
