import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/Models/Users.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/screens/Home.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateUser extends StatefulWidget {
  final DocumentSnapshot userId;

  UpdateUser({required this.userId});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  bool isObscure = true;
  var username = TextEditingController();
  var pass = TextEditingController();
  var confPass = TextEditingController();
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var nationality = TextEditingController();
  var address = TextEditingController();
  var gender = TextEditingController();
  var phoneController = TextEditingController();
  IconData icon = FontAwesomeIcons.solidEye;
  IconData icon2 = FontAwesomeIcons.solidEye;

  @override
  void initState() {
    firstname = TextEditingController(text: widget.userId.get("First Name"));
    lastname = TextEditingController(text: widget.userId.get("Last Name"));
    phoneController =
        TextEditingController(text: widget.userId.get("Phone Number"));
    nationality = TextEditingController(text: widget.userId.get("Country"));
    address = TextEditingController(text: widget.userId.get("Address"));
    gender = TextEditingController(text: widget.userId.get("Gender"));
    pass = TextEditingController(text: widget.userId.get("Password"));
    username = TextEditingController(text: widget.userId.get("Username"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    TextStyle fontStyle = TextStyle(
        fontSize: 20 / scaleFactor,
        color: Colors.white,
        fontFamily: "Raleway-Regular");
    return Stack(children: [
      BackGroundImage(
          image:
              "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg"),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Update User Info",
            style: infoStyleTXT,
            textScaleFactor: 1.1,
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
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 20,
                        // ),
                        getDefaultTextFormField(
                          isReadable: false,
                          obscure: false,
                          lblText: 'First Name',
                          txtInputAction: TextInputAction.next,
                          textEditingController: firstname,
                          type: TextInputType.text,
                          iconData: FontAwesomeIcons.user,
                          style: fontStyle,
                        ),
                        getDefaultTextFormField(
                            isReadable: false,
                            obscure: false,
                            iconData: FontAwesomeIcons.user,
                            lblText: 'Last Name',
                            txtInputAction: TextInputAction.next,
                            textEditingController: lastname,
                            type: TextInputType.text,
                            style: fontStyle),
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
                                  phoneController.text =
                                      "+${country.phoneCode}";
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
                            textEditingController: phoneController,
                            type: TextInputType.phone,
                            style: fontStyle,
                            submitted: () {
                              print(phoneController.text);
                            }),
                        getDefaultTextFormField(
                          isReadable: false,
                          obscure: false,
                          iconData: FontAwesomeIcons.addressCard,
                          lblText: 'Address',
                          txtInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          style: fontStyle,
                          textEditingController: address,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey[300]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Gender",
                                  style: fontStyle,
                                ),
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
                        getDefaultTextFormField(
                          isReadable: false,
                          obscure: false,
                          iconData: FontAwesomeIcons.user,
                          lblText: 'Username',
                          txtInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          style: fontStyle,
                          textEditingController: username,
                        ),
                        getDefaultTextFormField(
                          isReadable: false,
                          textEditingController: pass,
                          obscure: isObscure,
                          iconData: FontAwesomeIcons.lock,
                          lblText: 'Password',
                          style: fontStyle,
                          txtInputAction: TextInputAction.next,
                          iconData2: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                                if (isObscure == true) {
                                  icon = FontAwesomeIcons.solidEye;
                                } else {
                                  icon = FontAwesomeIcons.solidEyeSlash;
                                }
                              });
                            },
                            icon: Icon(
                              icon,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: MaterialButton(
                            // height: size.height*0.1,
                            height: 65,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onPressed: () async {
                              if (_checkRegisterFields() == true) {
                                if (RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$')
                                    .hasMatch(pass.text)) {
                                  final result =
                                      await Connectivity().checkConnectivity();
                                  if (result == ConnectivityResult.wifi ||
                                      result == ConnectivityResult.mobile) {
                                    Users user = Users(
                                      firstname: firstname.text,
                                      country: nationality.text,
                                      lastname: lastname.text,
                                      phonenumber: phoneController.text,
                                      gender: gender.text,
                                      address: address.text,
                                      password: pass.text,
                                      username: username.text,
                                    );
                                    widget.userId.reference.update({
                                      "First Name": user.firstname,
                                      "Last Name": user.lastname,
                                      "Country": user.country,
                                      "Gender": user.gender,
                                      "Address": user.address,
                                      "Password": user.password,
                                      "Username": user.username,
                                      "Phone Number": user.phonenumber
                                    }).whenComplete(() {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                  userId: widget.userId.id)));
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
                                                  BorderRadius.circular(12)),
                                          content: SingleChildScrollView(
                                            child: Text(
                                                "Password should contain\n ▪at least one upper case letter\n ▪at least one lower case letter\n ▪at least one digit\n ▪at least one special character\n ▪minimum 8 in length",textScaleFactor: 1.4,),
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
                                                BorderRadius.circular(12)),
                                        title: Text("Empty Fields"),
                                        content:
                                            SingleChildScrollView(child: Text("Can't keep any empty field",textScaleFactor: 1.4,)),
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
                                Text('Update', style: buttonStyleTXT, textScaleFactor: 2.5,),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.check_circle_outline,
                                    size: 25, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  bool _checkRegisterFields() {
    if (username.text.isEmpty ||
        pass.text.isEmpty ||
        firstname.text.isEmpty ||
        lastname.text.isEmpty ||
        phoneController.text.isEmpty ||
        nationality.text.isEmpty ||
        address.text.isEmpty ||
        gender.text.isEmpty) return false;
    return true;
  }
}
