import 'package:senior_project/Models/Person.dart';

class Users extends Person {
  final String username, password;

  Users(
      {required String firstname,
      required String lastname,
      required String country,
      required String phonenumber,
      required String address,
      required String gender,
      required this.username,
      required this.password})
      : super(
            firstname: firstname,
            lastname: lastname,
            country: country,
            phonenumber: phonenumber,
            address: address,
            gender: gender);
}
