import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  String username;
  String password;
  int age;
  DateTime dob;
  bool validated;
  Address address;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.age,
    required this.dob,
    required this.validated,
    required this.address,
  });

  factory User.create(
      {required String username,
      required String password,
      required int age,
      required DateTime dob,
      required Address address}) {
    final id = username + password;
    return User(
      id: id,
      username: username,
      password: password,
      age: age,
      dob: dob,
      validated: false,
      address: address,
    );
  }

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      id: data!['id'],
      username: data['username'],
      password: data['password'],
      age: data['age'],
      dob: data['dob'],
      validated: data['validated'],
      address: data['address'],
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      age: json['age'],
      dob: DateTime.parse(json['dob']),
      validated: json['validated'],
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "age": age,
      "dob": dob.toString(),
      "validated": validated,
      "address": address.toFirestore(),
    };
  }
}

class Address {
  String postal;
  String street;
  String province;

  Address({
    required this.postal,
    required this.street,
    required this.province,
  });

  factory Address.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Address(
        postal: data!['postal'],
        street: data['street'],
        province: data['province']);
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      postal: json['postal'],
      street: json['street'],
      province: json['province'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "postal": postal,
      "street": street,
      "province": province,
    };
  }
}
