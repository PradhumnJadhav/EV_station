// import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:log_in/Helpers/home.dart';
import 'package:log_in/l10n/l10n.dart';
import 'package:log_in/Users%20servies/login.dart';
import 'package:log_in/Users%20servies/register.dart';
import 'package:log_in/Helpers/checkuser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:log_in/splash_screen.dart';
import 'package:log_in/Maps/mapPage.dart';
import 'package:log_in/Users%20servies/resetPassword.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splash_screen',
    routes: {
      'login': (context) => MyLogin(),
      'register': (context) => MyRegister(),
      'splash_screen': (context) => Mysplash(),
      'flutter': (context) => HomePage(title: 'flutter'),
      'map': (context)=> SimpleMap(),
      'resetPassword':(context) => ResetPasswordPage(),
    },
    supportedLocales: L10n.all,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,

    ],
  ));
}
