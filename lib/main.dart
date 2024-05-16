import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/user/user_repository.dart';
import 'features/user/screens/welcome/welcome_page.dart';
import 'firebase_options.dart';
import 'global/theme/style.dart';
Future<void>  main() async {
 WidgetsFlutterBinding.ensureInitialized();
/// need update for ios and make fix in firbase for ios register url schema : go toin video 7H 20m upfate ios by mac ios emaulator cd ios and pod update

  /// GetX local storage
  await GetStorage.init();


  /// await splash until other items load
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  /// initialize firebase and  authentication repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
          (FirebaseApp value) => Get.put(UserRepository()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: tabColor,
            brightness: Brightness.dark
        ),
        scaffoldBackgroundColor: backgroundColor,
        dialogBackgroundColor: appBarColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ),
      ),
      home: WelcomePage(),
    );
  }
}
