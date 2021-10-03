import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/screens/Home.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdatePassword extends StatefulWidget {
  final String userId;

  UpdatePassword({required this.userId});

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool isObscure = true;
  bool isObscure2 = true;
  IconData icon = FontAwesomeIcons.solidEye;
  IconData icon2 = FontAwesomeIcons.solidEye;
  var pass = TextEditingController();
  var confPass = TextEditingController();
  CollectionReference userRef = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Stack(children: [
      BackGroundImage(
          image:
              "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg"),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Register New Password',
              style: infoStyleTXT,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getDefaultTextFormField(
                isReadable: false,
                textEditingController: pass,
                obscure: isObscure,
                iconData: FontAwesomeIcons.lock,
                style: TextStyle(
                    fontSize: 20 / scaleFactor,
                    color: Colors.white,
                    fontFamily: "Raleway-Regular"),
                lblText: 'Password',
                txtInputAction: TextInputAction.done,
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
              getDefaultTextFormField(
                isReadable: false,
                textEditingController: confPass,
                obscure: isObscure2,
                iconData: FontAwesomeIcons.unlock,
                lblText: 'Confirm Password',
                style: TextStyle(
                    fontSize: 20 / scaleFactor,
                    color: Colors.white,
                    fontFamily: "Raleway-Regular"),
                txtInputAction: TextInputAction.done,
                iconData2: IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure2 = !isObscure2;
                      if (isObscure2 == true) {
                        icon2 = FontAwesomeIcons.solidEye;
                      } else {
                        icon2 = FontAwesomeIcons.solidEyeSlash;
                      }
                    });
                  },
                  icon: Icon(
                    icon2,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: MaterialButton(
                  // height: size.height*0.1,
                  height: 65,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () async {
                    if (pass.text.isEmpty || confPass.text.isEmpty) {
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
                                  borderRadius: BorderRadius.circular(12)),
                              content: SingleChildScrollView(child: Text("Can't keep an empty field",textScaleFactor: 1.4,)),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK")),
                              ],
                            );
                          });
                    } else {
                      if (pass.text != confPass.text) {
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
                                    borderRadius: BorderRadius.circular(12)),
                                content: SingleChildScrollView(
                                  child: Text(
                                      "Password and Confirm password do not match",textScaleFactor: 1.4,),
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
                      } else {
                        final result = await Connectivity().checkConnectivity();
                        if (result == ConnectivityResult.wifi ||
                            result == ConnectivityResult.mobile) {
                          userRef.doc(widget.userId).update({
                            "Password": pass.text,
                            "isLoggedIn": true
                          }).whenComplete(() => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        userId: widget.userId,
                                      ))));
                        } else {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: "You don't have internet access",
                            ),
                          );
                        }
                      }
                    }
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Update', style: buttonStyleTXT,textScaleFactor: 2.5,),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.app_registration_outlined,
                          size: 25, color: Colors.white,)
                    ],
                  ),
                ),
              )
            ],
          ))
    ]);
  }
}
