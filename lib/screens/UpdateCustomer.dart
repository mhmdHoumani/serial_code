import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/Models/Customer.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/screens/Home.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateCustomer extends StatefulWidget {
  final DocumentSnapshot customer;
  final String userId;

  UpdateCustomer({required this.customer, required this.userId});

  @override
  _UpdateCustomerState createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var phoneNbr = TextEditingController();
  var nationality = TextEditingController();
  var address = TextEditingController();
  var gender = TextEditingController();

  @override
  void initState() {
    firstname = TextEditingController(text: widget.customer.get("First Name"));
    lastname =
        TextEditingController(text: "${widget.customer.get("Last Name")}");
    phoneNbr =
        TextEditingController(text: "${widget.customer.get("Phone Number")}");
    nationality =
        TextEditingController(text: "${widget.customer.get("Country")}");
    address = TextEditingController(text: "${widget.customer.get("Address")}");
    gender = TextEditingController(text: "${widget.customer.get("Gender")}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    var fontStyle = TextStyle(
        fontSize: 20 / scaleFactor,
        color: Colors.white,
        fontFamily: "Raleway-Regular");
    return Stack(
      children: [
        BackGroundImage(
            image:
                "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                "Update Customer Info",
                style: infoStyleTXT,
                textScaleFactor: 1.1,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getDefaultTextFormField(
                                  isReadable: false,
                                  obscure: false,
                                  lblText: 'First Name',
                                  style: fontStyle,
                                  txtInputAction: TextInputAction.next,
                                  textEditingController: firstname,
                                  type: TextInputType.text,
                                  iconData: FontAwesomeIcons.user),
                              getDefaultTextFormField(
                                isReadable: false,
                                obscure: false,
                                iconData: FontAwesomeIcons.user,
                                style: fontStyle,
                                lblText: 'Last Name',
                                txtInputAction: TextInputAction.next,
                                textEditingController: lastname,
                                type: TextInputType.text,
                              ),
                              getDefaultTextFormField(
                                  isReadable: false,
                                  obscure: false,
                                  iconData: FontAwesomeIcons.flag,
                                  lblText: 'Country',
                                  style: fontStyle,
                                  txtInputAction: TextInputAction.next,
                                  textEditingController: nationality,
                                  submitted: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      // optional. Shows phone code before the country name.
                                      onSelect: (Country country) {
                                        nationality.text = country.name;
                                        phoneNbr.text = "+${country.phoneCode}";
                                        print(
                                            'Select country: ${country.displayName}');
                                      },
                                    );
                                  }),
                              getDefaultTextFormField(
                                  isReadable: false,
                                  obscure: false,
                                  iconData: FontAwesomeIcons.phoneAlt,
                                  lblText: 'Phone Number',
                                  txtInputAction: TextInputAction.next,
                                  textEditingController: phoneNbr,
                                  style: fontStyle,
                                  type: TextInputType.phone,
                                  submitted: () {
                                    print(phoneNbr.text);
                                  }),
                              getDefaultTextFormField(
                                isReadable: false,
                                style: fontStyle,
                                obscure: false,
                                iconData: FontAwesomeIcons.addressCard,
                                lblText: 'Address',
                                txtInputAction: TextInputAction.next,
                                type: TextInputType.text,
                                textEditingController: address,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300]!.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Text("Gender", style: fontStyle),
                                      Radio(
                                        value: "Male",
                                        groupValue: gender.text,
                                        onChanged: (value) {
                                          setState(() {
                                            gender.text = value as String;
                                          });
                                        },
                                      ),
                                      Text(
                                        "Male",
                                        style: whiteStyleTXT,
                                        textScaleFactor: 1,
                                      ),
                                      Radio(
                                        value: "Female",
                                        groupValue: gender.text,
                                        onChanged: (value) {
                                          setState(() {
                                            gender.text = value as String;
                                          });
                                        },
                                      ),
                                      Text(
                                        "Female",
                                        style: whiteStyleTXT,
                                        textScaleFactor: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: MaterialButton(
                                  height: 65,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  onPressed: () async {
                                    if (_checkRegisterFields() == true) {
                                      final result = await Connectivity()
                                          .checkConnectivity();
                                      if (result == ConnectivityResult.mobile ||
                                          result == ConnectivityResult.wifi) {
                                        Customer c = Customer(
                                            firstname: firstname.text,
                                            lastname: lastname.text,
                                            country: nationality.text,
                                            phonenumber: phoneNbr.text,
                                            address: address.text,
                                            gender: gender.text);
                                        widget.customer.reference.update({
                                          "First Name": c.firstname,
                                          "Last Name": c.lastname,
                                          "Country": c.country,
                                          "Phone Number": c.phonenumber,
                                          "Address": c.address,
                                          "Gender": c.gender,
                                        }).whenComplete(() {
                                          print(widget.userId);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(
                                                          userId:
                                                              widget.userId)));
                                        });
                                      } else {
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.error(
                                            message:
                                                "You don't have internet access",
                                          ),
                                        );
                                      }
                                    } else {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              contentTextStyle: TextStyle(
                                                fontFamily: "Raleway-Regular",
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              content: SingleChildScrollView(
                                                child: Text(
                                                    "Can't keep an empty field",textScaleFactor: 1.4,),
                                              ),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK")),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  color: Colors.blue,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Update',
                                        style: buttonStyleTXT,
                                        textScaleFactor: 2.5,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.check_circle_outline,
                                          size: 25, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  bool _checkRegisterFields() {
    if (firstname.text.isEmpty ||
        lastname.text.isEmpty ||
        phoneNbr.text.isEmpty ||
        nationality.text.isEmpty ||
        address.text.isEmpty ||
        gender.text.isEmpty) return false;
    return true;
  }
}
