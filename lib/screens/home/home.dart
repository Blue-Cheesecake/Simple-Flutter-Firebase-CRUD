import 'package:flutter/material.dart';
import 'package:simple_flutter_firebase_crud/screens/create/create_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/delete/delete_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/read/read_screen.dart';
import 'package:simple_flutter_firebase_crud/screens/update/update_screen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  static const routeName = "/Home";

  final List<Item> items = [
    Item("Create", CreateScreen.routeName),
    Item("Read", ReadScreen.routeName),
    Item("Update", UpdateScreen.routeName),
    Item("Delete", DeleteScreen.routeName),
  ];

  Widget _buildAnchor(BuildContext context, String title, String destRoute) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(destRoute);
          },
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase CRUD'),
        centerTitle: true,
        elevation: 7,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map((e) => _buildAnchor(context, e.title, e.destRoute))
              .toList(),
        ),
      ),
    );
  }
}

class Item {
  final String title;
  final String destRoute;

  Item(this.title, this.destRoute);
}
