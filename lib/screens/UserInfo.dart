import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/screens/UpdateUser.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';

class UserInfo extends StatefulWidget {
  final DocumentSnapshot userId;

  UserInfo({required this.userId});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
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
            "User's Info",
            style: infoStyleTXT,
            textScaleFactor: 1.5,
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
                        getDefaultTextFormField(
                            isReadable: true,
                            obscure: false,
                            lblText: 'First Name',
                            txtInputAction: TextInputAction.next,
                            textEditingController: firstname,
                            type: TextInputType.text,
                            iconData: FontAwesomeIcons.user,
                            style: fontStyle),
                        getDefaultTextFormField(
                            isReadable: true,
                            obscure: false,
                            iconData: FontAwesomeIcons.user,
                            lblText: 'Last Name',
                            txtInputAction: TextInputAction.next,
                            textEditingController: lastname,
                            type: TextInputType.text,
                            style: fontStyle),
                        getDefaultTextFormField(
                            isReadable: true,
                            obscure: false,
                            iconData: FontAwesomeIcons.flag,
                            lblText: 'Country',
                            txtInputAction: TextInputAction.next,
                            textEditingController: nationality,
                            style: fontStyle),
                        getDefaultTextFormField(
                            isReadable: true,
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
                            isReadable: true,
                            obscure: false,
                            iconData: FontAwesomeIcons.addressCard,
                            lblText: 'Address',
                            txtInputAction: TextInputAction.next,
                            type: TextInputType.text,
                            textEditingController: address,
                            style: fontStyle),
                        getDefaultTextFormField(
                            isReadable: true,
                            obscure: false,
                            iconData: FontAwesomeIcons.addressCard,
                            lblText: 'Gender',
                            txtInputAction: TextInputAction.next,
                            type: TextInputType.text,
                            textEditingController: gender,
                            style: fontStyle),
                        getDefaultTextFormField(
                          isReadable: true,
                          obscure: false,
                          iconData: FontAwesomeIcons.user,
                          lblText: 'Username',
                          txtInputAction: TextInputAction.next,
                          type: TextInputType.text,
                          textEditingController: username,
                          style: fontStyle,
                        ),
                        getDefaultTextFormField(
                          isReadable: true,
                          textEditingController: pass,
                          obscure: isObscure,
                          iconData: FontAwesomeIcons.lock,
                          lblText: 'Password',
                          txtInputAction: TextInputAction.next,
                          style: fontStyle,
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
                      ],
                    ),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateUser(
                                  userId: widget.userId,
                                )));
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Edit', style: buttonStyleTXT, textScaleFactor: 2.5,),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.update, size: 25, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
