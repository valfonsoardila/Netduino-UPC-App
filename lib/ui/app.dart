import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:netduino_upc_app/ui/anim/introFull_app.dart';
import 'package:netduino_upc_app/ui/auth/login.dart';
import 'package:netduino_upc_app/ui/auth/perfil.dart';
import 'package:netduino_upc_app/ui/auth/register.dart';
import 'package:netduino_upc_app/ui/auth/restaurar.dart';
import 'package:netduino_upc_app/ui/home/main_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NetduinoUPC App',
      theme: ThemeData.dark(),
      initialRoute: '/principal',
      routes: {
        // "/": (context) => const IntroSimple(),
        //"/": (context) => const IntroFull(),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/restaurar": (context) => const Restaurar(),
        "/perfil": (context) => const Perfil(),
        "/principal": (context) => const MainScreen(),
      },
    );
  }
}
