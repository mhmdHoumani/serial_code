import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/screens/UpdatePassword.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey();
  bool showLoading = false;
  CollectionReference userRef = FirebaseFirestore.instance.collection("Users");

  @override
  void initState(){
    super.initState();
    showTopSnackBar(
      context,

      CustomSnackBar.info(
        message: "You need to specify the country code",

      ),
    );
  }


  void signnWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UpdatePassword(
                      userId: authCredential.user!.uid,
                    )));
      }
    } on FirebaseAuthException catch (e) {
      // TODO
      setState(() {
        showLoading = false;
      });
      _scaffoldstate.currentState!.showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  getMobileFormWidget(context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      child: Form(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          getDefaultTextFormField(
              isReadable: false,
              obscure: false,
              lblText: 'Phone Number',
              txtInputAction: TextInputAction.done,
              textEditingController: phoneController,
              style: TextStyle(
                  fontSize: 20 / scaleFactor,
                  color: Colors.white,
                  fontFamily: "Raleway-Regular"),
              iconData: FontAwesomeIcons.phone),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: MaterialButton(
              // height: size.height*0.1,
              height: 65,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () async {
                if (phoneController.text.isEmpty) {
                  showTopSnackBar(
                    context,
                    CustomSnackBar.error(
                      message: "Can't have an empty field",
                    ),
                  );
                } else {
                  final result = await Connectivity().checkConnectivity();
                  if (result == ConnectivityResult.wifi ||
                      result == ConnectivityResult.mobile) {
                    userRef.where("Phone Number",isEqualTo:phoneController.text).get().then((value) async {
                      if(value.docs.length==0)
                        {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: "This phone number isn't registered for an existing user",
                            ),
                          );
                        }
                      else
                        {
                          setState(() {
                            showLoading = true;
                          });
                          await _auth.verifyPhoneNumber(
                              phoneNumber: phoneController.text,
                              verificationCompleted: (phoneAuthCredentials) async {
                                setState(() {
                                  showLoading = false;
                                });
                                //signnWithPhoneAuthCredential(phoneAuthCredentials);
                              },
                              verificationFailed: (verificationFailed) {
                                setState(() {
                                  showLoading = false;
                                });
                                _scaffoldstate.currentState!.showSnackBar(SnackBar(
                                    content: Text(verificationFailed.message!)));
                                //the key is replacing the context
                              },
                              codeSent: (verificationId, resendingToken) async {
                                setState(() {
                                  showLoading = false;
                                  currentState =
                                      MobileVerificationState.SHOW_OTP_FORM_STATE;
                                  this.verificationId = verificationId;
                                });
                              },
                              codeAutoRetrievalTimeout: (verificationId) async {});
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
                    'Send',
                    style: buttonStyleTXT,
                    textScaleFactor: 2.5,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.send, size: 25, color: Colors.white),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  getOtpFormWidget(context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      child: Form(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          getDefaultTextFormField(
              isReadable: false,
              obscure: false,
              lblText: 'Enter Code',
              txtInputAction: TextInputAction.done,
              style: TextStyle(
                  fontSize: 20 / scaleFactor,
                  color: Colors.white,
                  fontFamily: "Raleway-Regular"),
              textEditingController: otpController,
              iconData: FontAwesomeIcons.code),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: MaterialButton(
              height: 65,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () async {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: this.verificationId!,
                        smsCode: otpController.text);
                signnWithPhoneAuthCredential(phoneAuthCredential);
              },
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify',
                    style: buttonStyleTXT,
                    textScaleFactor: 2.5,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.send, size: 25, color: Colors.white),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

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
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Phone Verification',
                    textStyle: TextStyle(
                        fontFamily: "Raleway-Thin",
                        fontSize: 30 / scaleFactor,
                        color: Color(0xffbfbfbf),
                        fontWeight: FontWeight.w500),
                    colors: [Colors.white, Colors.grey],
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                totalRepeatCount: 1,
                isRepeatingAnimation: true,
              ),
            ),
            //centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            child: showLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context),
            padding: EdgeInsets.all(16),
          ))
    ]);
  }
}
