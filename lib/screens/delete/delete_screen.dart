import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_flutter_firebase_crud/constants/collection.dart';
import 'package:simple_flutter_firebase_crud/models/user.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  static const routeName = "/delete";

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
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

  void _performLoadingData() {
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
  void initState() {
    super.initState();
    _performLoadingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: _isLoading
              ? const CircularProgressIndicator()
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
      trailing: IconButton(
        onPressed: () => _showAlertDialog(context, user.id),
        icon: const Icon(Icons.delete),
      ),
    );
  }

  Future<bool> _deleteUser(String userID) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection(Collection.users).doc(userID).delete();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  void _showAlertDialog(BuildContext context, String userID) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        // Perform delete here

        _deleteUser(userID).then((value) {
          Navigator.of(context).pop();
          setState(() {
            _performLoadingData();
          });
        });
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this user?"),
          content: Text("Performs this action can't be reversed."),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }
}
