import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/screens/CreateNewUser.dart';
import 'package:senior_project/screens/ForgotPassword.dart';
import 'package:senior_project/screens/Home.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;
  IconData icon = FontAwesomeIcons.solidEye;
  var username = TextEditingController();
  var password = TextEditingController();
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg",
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 4,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Money Serial Number Extraction',
                            textStyle: TextStyle(
                              fontSize: 40 / scaleFactor,
                              fontFamily: "Raleway-Medium",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 200),
                            cursor: '|'),
                      ],
                      totalRepeatCount: 10,
                      pause: const Duration(milliseconds: 500),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            children: [
                              getDefaultTextFormField(
                                obscure: false,
                                iconData: FontAwesomeIcons.user,
                                lblText: 'Username',
                                style: fontStyle,
                                txtInputAction: TextInputAction.next,
                                textEditingController: username,
                                isReadable: false,
                              ),
                              getDefaultTextFormField(
                                isReadable: false,
                                textEditingController: password,
                                obscure: isObscure,
                                iconData: FontAwesomeIcons.unlock,
                                lblText: 'Password',
                                style: fontStyle,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: whiteStyleTXT,
                                    textScaleFactor: 1.2,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateNewUser()));
                                    },
                                    child: Text(
                                      "Create one",
                                      style: blueStyleTXT,
                                      textScaleFactor: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                          height: 60,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onPressed: () async {
                            if (username.text.isEmpty ||
                                password.text.isEmpty) {
                              // Get.defaultDialog(title: "Empty Fields",middleText: "Can't leave any empty field");
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
                                      title: Text(
                                        "Empty Fields",
                                        textScaleFactor: 1.6,
                                      ),
                                      content: SingleChildScrollView(
                                        child: Text(
                                          "Can't keep an empty field ",
                                          textScaleFactor: 1.4,
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "OK",
                                              textScaleFactor: 1.2,
                                            )),
                                      ],
                                    );
                                  });
                            } else {
                              final result =
                                  await Connectivity().checkConnectivity();
                              if (result == ConnectivityResult.wifi ||
                                  result == ConnectivityResult.mobile) {
                                userRef
                                    .where("Username", isEqualTo: username.text)
                                    .get()
                                    .then((value) async {
                                  if (value.docs.length == 0) {
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
                                                "This user does not exist",
                                                textScaleFactor: 1.4,
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    textScaleFactor: 1.0,
                                                  )),
                                            ],
                                          );
                                        });
                                  } else {
                                    if (value.docs.toList()[0]["Password"] !=
                                        password.text) {
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
                                                    "Password does not match",
                                                    textScaleFactor: 1.4),
                                              ),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK",
                                                        textScaleFactor: 1.0)),
                                              ],
                                            );
                                          });
                                    } else {
                                      if (value.docs.toList()[0]
                                              ["isLoggedIn"] ==
                                          false) {
                                        DocumentSnapshot user = await userRef
                                            .doc(value.docs[0].id)
                                            .get();
                                        user.reference
                                            .update({"isLoggedIn": true});
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setBool('isLogged', true);
                                        pref.setString(
                                            'userID', value.docs[0].id);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                        userId:
                                                            value.docs[0].id)));
                                      } else {
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.info(
                                            message:
                                                "This account is already logged in from another device",
                                          ),
                                        );
                                      }
                                    }
                                  }
                                });
                              } else {
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message: "You don't have internet access",
                                  ),
                                );
                              }
                            }
                          },
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login',
                                style: buttonStyleTXT,
                                textScaleFactor: 2.5,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.login, size: 25, color: Colors.white),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: whiteStyleTXT,
                            textScaleFactor: 1.0,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Text(
                              "Click here",
                              style: blueStyleTXT,
                              textScaleFactor: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
