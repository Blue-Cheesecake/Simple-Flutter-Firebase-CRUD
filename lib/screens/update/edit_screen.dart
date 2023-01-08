import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_firebase_crud/constants/collection.dart';
import 'package:simple_flutter_firebase_crud/models/user.dart';
import 'package:simple_flutter_firebase_crud/screens/update/update_screen.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  static const routeName = "${UpdateScreen.routeName}/edit";

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _usernameCrt = TextEditingController();

  final _passwordCrt = TextEditingController();

  final _ageCrt = TextEditingController();

  late DateTime _dobCrt;

  final _postalCrt = TextEditingController();

  final _provinceCrt = TextEditingController();

  final _streetCrt = TextEditingController();

  late User _user;

  late bool _firstInitiate;

  late final String _previousId;

  @override
  void initState() {
    super.initState();
    _firstInitiate = true;
  }

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
    if (_firstInitiate) {
      _user = ModalRoute.of(context)?.settings.arguments as User;
      _previousId = _user.id;
      _usernameCrt.text = _user.username;
      _passwordCrt.text = _user.password;
      _ageCrt.text = _user.age.toString();
      _dobCrt = _user.dob;
      _postalCrt.text = _user.address.postal;
      _provinceCrt.text = _user.address.province;
      _streetCrt.text = _user.address.street;
      _firstInitiate = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
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

            /// Postal code and Edit button
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
                    future: _edit(_user),
                    builder: (context, snapshot) {
                      print("loading");
                      if (snapshot.hasData) {
                        if (snapshot.data == false) {
                          return const Text(
                            'Failed!',
                            style: TextStyle(color: Colors.red),
                          );
                        }
                        return const Text(
                          'Edited!',
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
                      _user = User.create(
                        username: _usernameCrt.text,
                        password: _passwordCrt.text,
                        age: int.parse(_ageCrt.text),
                        dob: _dobCrt,
                        address: Address(
                            postal: _postalCrt.text,
                            street: _streetCrt.text,
                            province: _provinceCrt.text),
                      );
                      _pressedCreate = true;
                    });
                  },
                  child: Text("Edit"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _edit(User user) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection(Collection.users).doc(_previousId).delete();
      await db
          .collection(Collection.users)
          .withConverter(
            fromFirestore: User.fromFirestore,
            toFirestore: (value, options) => user.toFirestore(),
          )
          .doc(user.id)
          .set(user);
    } catch (e) {
      return false;
    } finally {
      await Future.delayed(const Duration(milliseconds: 700));
    }

    return true;
  }
}
