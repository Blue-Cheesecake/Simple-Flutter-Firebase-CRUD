import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_firebase_crud/screens/create/create_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/delete/delete_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/home/home.dart';
import 'package:simple_flutter_firebase_crud/screens/read/read_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/update/edit_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/update/update_screen.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple Flutter Firebase CRUD",
      initialRoute: Home.routeName,
      routes: {
        Home.routeName: (context) => Home(),
        CreateScreen.routeName: (context) => CreateScreen(),
        ReadScreen.routeName: (context) => ReadScreen(),
        UpdateScreen.routeName: (context) => UpdateScreen(),
        EditScreen.routeName: (context) => EditScreen(),
        DeleteScreen.routeName: (context) => DeleteScreen(),
      },
    );
  }
}
