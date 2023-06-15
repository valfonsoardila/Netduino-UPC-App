import 'package:netduino_upc_app/domain/controller/controllerPerfilUser.dart';
import 'package:netduino_upc_app/domain/controller/controllerUserFirebase.dart';
import 'package:netduino_upc_app/ui/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  GetPlatform.isWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyA6ZaDCfcAP6eZBsqlpHFjczysU7Kq3QBQ",
            appId: "1:164567058319:android:a931420f65b287cd686dfa",
            messagingSenderId: "3676093271061493906",
            projectId: "netduino-upc",
            authDomain: "netduino-upc.firebaseapp.com",
            storageBucket: "netduino-upc.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  Get.put(ControlUserAuth());
  Get.put(ControlUserPerfil());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const App());
}
