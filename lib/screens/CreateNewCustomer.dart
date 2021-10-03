import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/Models/Customer.dart';
import 'package:senior_project/screens/Home.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../StyleTXT.dart';

class CreateNewCustomer extends StatefulWidget {
  final String userId;

  CreateNewCustomer({required this.userId});

  @override
  _CreateNewCustomerState createState() => _CreateNewCustomerState();
}

class _CreateNewCustomerState extends State<CreateNewCustomer> {
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var phoneNbr = TextEditingController();
  var nationality = TextEditingController();
  var address = TextEditingController();
  var gender = TextEditingController();
  late String id = widget.userId;
  CollectionReference userRef = FirebaseFirestore.instance.collection("Users");

  _CreateNewCustomerState();

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
                'Create Customer',
                style: titleStyleTXT,
                textScaleFactor: 1.5,
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
                                  txtInputAction: TextInputAction.next,
                                  textEditingController: firstname,
                                  type: TextInputType.text,
                                  style: fontStyle,
                                  iconData: FontAwesomeIcons.user),
                              getDefaultTextFormField(
                                isReadable: false,
                                obscure: false,
                                iconData: FontAwesomeIcons.user,
                                lblText: 'Last Name',
                                txtInputAction: TextInputAction.next,
                                textEditingController: lastname,
                                type: TextInputType.text,
                                style: TextStyle(
                                    fontSize: 20 / scaleFactor,
                                    color: Colors.white,
                                    fontFamily: "Raleway-Regular"),
                              ),
                              getDefaultTextFormField(
                                  isReadable: false,
                                  obscure: false,
                                  iconData: FontAwesomeIcons.flag,
                                  lblText: 'Country',
                                  txtInputAction: TextInputAction.next,
                                  textEditingController: nationality,
                                  style: fontStyle,
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
                                  type: TextInputType.phone,
                                  style: fontStyle,
                                  submitted: () {
                                    print(phoneNbr.text);
                                  }),
                              getDefaultTextFormField(
                                isReadable: false,
                                obscure: false,
                                iconData: FontAwesomeIcons.addressCard,
                                lblText: 'Address',
                                txtInputAction: TextInputAction.next,
                                type: TextInputType.text,
                                textEditingController: address,
                                style: fontStyle,
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
                                        textScaleFactor: 1.0,
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
                                        textScaleFactor: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: MaterialButton(
                                  // height: size.height*0.1,
                                  height: 65,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  onPressed: () async {
                                    // Navigator.pop(context);
                                    if (_checkRegisterFields() == true) {
                                      final result = await Connectivity()
                                          .checkConnectivity();
                                      if (result == ConnectivityResult.wifi ||
                                          result == ConnectivityResult.mobile) {
                                        userRef
                                            .doc(id)
                                            .collection("Customers")
                                            .where("Phone Number",
                                                isEqualTo: phoneNbr.text)
                                            .get()
                                            .then((value) async {
                                          if (value.docs.length == 0) {
                                            DocumentSnapshot temp =
                                                await userRef.doc(id).get();

                                            if (temp.get("Phone Number") ==
                                                phoneNbr.text) {
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                      content: Text(
                                                          "Can't create a customer and a user with the same phone number",textScaleFactor: 1.4,),
                                                      actions: [
                                                        FlatButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("OK")),
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              Customer c = Customer(
                                                  firstname: firstname.text,
                                                  lastname: lastname.text,
                                                  country: nationality.text,
                                                  phonenumber: phoneNbr.text,
                                                  address: address.text,
                                                  gender: gender.text);
                                              userRef
                                                  .doc(id)
                                                  .collection("Customers")
                                                  .add({
                                                "First Name": c.firstname,
                                                "Last Name": c.lastname,
                                                "Country": c.country,
                                                "Phone Number": c.phonenumber,
                                                "Address": c.address,
                                                "Gender": c.gender,
                                              }).whenComplete(() =>
                                                      Navigator.pop(context));
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    title: Text(
                                                        "Existing Customer"),
                                                    content: Text(
                                                        "This customer already exist",textScaleFactor: 1.4,),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("OK")),
                                                    ],
                                                  );
                                                });
                                          }
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
                                              content: Text(
                                                  "Can't keep an empty field",textScaleFactor: 1.4,),
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
                                        'Create',
                                        style: buttonStyleTXT,
                                        textScaleFactor: 2.5,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.person_add_outlined,
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
