import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_firebase_crud/constants/collection.dart';
import 'package:simple_flutter_firebase_crud/models/user.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  static const routeName = "/read";

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> _userIds;
  bool _isLoading = true;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchData() async {
    final db = FirebaseFirestore.instance;
    late List<QueryDocumentSnapshot<Map<String, dynamic>>> result;
    await db.collection(Collection.users).get().then((value) {
      result = value.docs;
    }).onError((error, stackTrace) {
      print(error);
    });
    return result;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _fetchData().then((value) {
      _userIds = value;
      Future.delayed(const Duration(milliseconds: 1000)).then((_) {
        setState(() {
          print("finished");
          print(_userIds);
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: _isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _userIds.length,
                  itemBuilder: (context, index) {
                    print(_userIds[index].data());
                    User user = User.fromJson(_userIds[index].data());
                    return _buildUserItem(user);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildUserItem(User user) {
    return ListTile(
      title: Text(user.username),
      subtitle: Text("Validated: ${user.validated}"),
    );
  }
}
