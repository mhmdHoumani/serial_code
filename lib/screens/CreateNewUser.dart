import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

class CreateNewUser extends StatefulWidget {
  @override
  _CreateNewUserState createState() => _CreateNewUserState();
}

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class _CreateNewUserState extends State<CreateNewUser> {
  bool isObscure = true;
  bool isObscure2 = true;
  var username = TextEditingController();
  var pass = TextEditingController();
  var confPass = TextEditingController();
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var nationality = TextEditingController();
  var address = TextEditingController();
  var gender = TextEditingController();
  IconData icon = FontAwesomeIcons.solidEye;
  IconData icon2 = FontAwesomeIcons.solidEye;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool showLoading = false;
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  void SignWithPhoneAuthCredential(
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
        userRef.doc(authCredential.user!.uid).set({
          "First Name": user.firstname,
          "Last Name": user.lastname,
          "Country": user.country,
          "Gender": user.gender,
          "Address": user.address,
          "Password": user.password,
          "Username": user.username,
          "Phone Number": user.phonenumber,
          "isLoggedIn": true
        }).whenComplete(() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      userId: authCredential.user!.uid,
                    ))));
      }
    } on FirebaseAuthException catch (e) {
      // TODO
      setState(() {
        showLoading = false;
      });
      _scaffoldState.currentState!.showSnackBar(SnackBar(
        content: Text(e.message!),
      ));
    }
  }

  getMobileFormWidget(context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    var fontStyle = TextStyle(
        fontSize: 20 / scaleFactor,
        color: Colors.white,
        fontFamily: "Raleway-Regular");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              child: Column(children: [
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
                  style: fontStyle,
                  txtInputAction: TextInputAction.next,
                  textEditingController: lastname,
                  type: TextInputType.text,
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
                          phoneController.text = "+${country.phoneCode}";
                          print('Select country: ${country.displayName}');
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
                  textEditingController: address,
                  style: fontStyle,
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
                        Text("Female",
                            style: whiteStyleTXT, textScaleFactor: 1.0),
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
                  textEditingController: username,
                  style: fontStyle,
                ),
                getDefaultTextFormField(
                  isReadable: false,
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
                getDefaultTextFormField(
                  isReadable: false,
                  textEditingController: confPass,
                  obscure: isObscure2,
                  iconData: FontAwesomeIcons.unlock,
                  lblText: 'Confirm Password',
                  txtInputAction: TextInputAction.done,
                  style: fontStyle,
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
                  padding: const EdgeInsets.only(top: 10.0),
                  child: MaterialButton(
                    // height: size.height*0.1,
                    height: 65,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onPressed: () async {
                      if (_checkRegisterFields() == true) {
                        if (pass.text == confPass.text) {
                          if (RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$')
                              .hasMatch(pass.text)) {
                            final result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.wifi ||
                                result == ConnectivityResult.mobile) {
                              userRef
                                  .where("Phone Number",
                                      isEqualTo: phoneController.text)
                                  .get()
                                  .then((value) {
                                if (value.docs.length == 0) {
                                  userRef
                                      .where("Username",
                                          isEqualTo: username.text)
                                      .get()
                                      .then((value) async {
                                    if (value.docs.length == 0) {
                                      setState(() {
                                        showLoading = true;
                                      });
                                      await _auth.verifyPhoneNumber(
                                          phoneNumber: phoneController.text,
                                          verificationCompleted:
                                              (phoneAuthCredentials) async {
                                            setState(() {
                                              showLoading = false;
                                            });
                                          },
                                          verificationFailed:
                                              (verificationFailed) {
                                            setState(() {
                                              showLoading = false;
                                            });
                                            _scaffoldState.currentState!
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        verificationFailed
                                                            .message!)));
                                            //the key is replacing the context
                                          },
                                          codeSent: (verificationId,
                                              resendingToken) async {
                                            setState(() {
                                              showLoading = false;
                                              currentState =
                                                  MobileVerificationState
                                                      .SHOW_OTP_FORM_STATE;
                                              this.verificationId =
                                                  verificationId;
                                            });
                                          },
                                          codeAutoRetrievalTimeout:
                                              (verificationID) async {});
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
                                                    "This Username is already taken",textScaleFactor: 1.4,),
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
                                  });
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
                                              "This phone number is already associated to an existing user",textScaleFactor: 1.4,
                                            ),
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
                              });
                            } else {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: "You don't have internet access",
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
                                        "Password should contain\n ▪at least one upper case letter\n ▪at least one lower case letter\n ▪at least one digit\n ▪at least one special character\n ▪minimum 8 in length",
textScaleFactor: 1.4,
                                      ),
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
                                      borderRadius: BorderRadius.circular(12)),
                                  content: SingleChildScrollView(
                                    child: Text(
                                      "Password and confirm password aren't equal",
                                      textScaleFactor: 1.4,
                                    ),
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
                                    borderRadius: BorderRadius.circular(12)),
                                title: Text("Empty Fields"),
                                content: SingleChildScrollView(child: Text("Can't keep any empty field",textScaleFactor: 1.4,)),
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
                          'Register',
                          style: buttonStyleTXT,
                          textScaleFactor: 2.5,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.how_to_reg_outlined,
                            size: 25, color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
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
              lblText: 'Enter Verification Code',
              txtInputAction: TextInputAction.done,
              textEditingController: otpController,
              style: TextStyle(
                  fontSize: 20 / scaleFactor,
                  color: Colors.white,
                  fontFamily: "Raleway-Regular"),
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
                SignWithPhoneAuthCredential(phoneAuthCredential);
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
    return Stack(
      children: [
        BackGroundImage(
            image:
                "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            //toolbarHeight: 80,
            //elevation: 10,
            title: Text(
              'Register New User',
              style: titleStyleTXT,
              textScaleFactor: 1.2,
            ),
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
            //padding: EdgeInsets.all(16),
          ),
        )
      ],
    );
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
