class User {
  String username;
  String password;
  int age;
  DateTime dob;
  bool validated;
  Address address;

  User({
    required this.username,
    required this.password,
    required this.age,
    required this.dob,
    required this.validated,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "age": age,
      "dob": dob.toString(),
      "validated": validated,
      "address": address.toJson(),
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

  Map<String, dynamic> toJson() {
    return {
      "postal": postal,
      "street": street,
      "province": province,
    };
  }
}
