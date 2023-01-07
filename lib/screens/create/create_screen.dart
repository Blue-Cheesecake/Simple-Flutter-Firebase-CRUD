import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_firebase_crud/constants/collection.dart';
import 'package:simple_flutter_firebase_crud/models/user.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  static const routeName = "/create";

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _usernameCrt = TextEditingController();

  final _passwordCrt = TextEditingController();

  final _ageCrt = TextEditingController();

  DateTime _dobCrt = DateTime.now();

  final _postalCrt = TextEditingController();

  final _provinceCrt = TextEditingController();

  final _streetCrt = TextEditingController();

  late User _user;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dobCrt,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _dobCrt) {
      setState(() {
        _dobCrt = picked;
      });
    }
  }

  bool _pressedCreate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Username
            ///
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
              controller: _usernameCrt,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),

            /// Password
            ///
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
              controller: _passwordCrt,
              keyboardType: TextInputType.text,
              obscureText: true,
              autocorrect: false,
            ),
            const SizedBox(height: 10),

            /// Age and DOB
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Age",
                    ),
                    controller: _ageCrt,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Row(
                  children: [
                    Text('${_dobCrt.toLocal()}'.split(' ')[0]),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text("Select DOB"))
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),

            /// Province ans Street
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Province",
                    ),
                    controller: _provinceCrt,
                    keyboardType: TextInputType.text,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Street",
                    ),
                    controller: _streetCrt,
                    keyboardType: TextInputType.text,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),

            /// Postal code and Create button
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Postal-Code",
                    ),
                    controller: _postalCrt,
                    keyboardType: TextInputType.number,
                  ),
                ),

                /// Loading and Show Successful
                ///
                if (_pressedCreate)
                  FutureBuilder(
                    future: _createUser(_user),
                    builder: (context, snapshot) {
                      print("loading");
                      if (snapshot.hasData) {
                        return const Text(
                          'Created!',
                          style: TextStyle(color: Colors.green),
                        );
                      }
                      _pressedCreate = false;
                      return const CircularProgressIndicator();
                    },
                  )
                else
                  const SizedBox.shrink(),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _user = User(
                        username: _usernameCrt.text,
                        password: _passwordCrt.text,
                        age: int.parse(_ageCrt.text),
                        dob: _dobCrt,
                        validated: false,
                        address: Address(
                            postal: _postalCrt.text,
                            street: _streetCrt.text,
                            province: _provinceCrt.text),
                      );
                      _pressedCreate = true;
                      print("pressed");
                    });
                  },
                  child: Text("Create"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _createUser(User user) async {
    final db = FirebaseFirestore.instance;
    await db.collection(Collection.users).add(user.toJson());
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}
