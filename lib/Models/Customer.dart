
import 'package:senior_project/Models/Person.dart';

class Customer extends Person {

  Customer(
      {required String firstname,
      required String lastname,
      required String country,
      required String phonenumber,
      required String address,
      required String gender}): super(firstname:firstname, lastname:lastname, country:country, phonenumber:phonenumber, address:address, gender:gender );
}
