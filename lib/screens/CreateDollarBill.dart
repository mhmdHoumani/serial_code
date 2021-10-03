import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_project/Models/DollarBill.dart';
import 'package:senior_project/screens/CustomerDetails.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../StyleTXT.dart';

class CreateDollarBill extends StatefulWidget {
  final DocumentSnapshot customer;
  final String userId;

  CreateDollarBill({required this.customer, required this.userId});

  @override
  _CreateDollarBillState createState() => _CreateDollarBillState();
}

class _CreateDollarBillState extends State<CreateDollarBill> {
  bool is1Checked = false;
  bool is2Checked = false;
  bool is5Checked = false;
  bool is10Checked = false;
  bool is20Checked = false;
  bool is50Checked = false;
  bool is100Checked = false;
  var serialNbController = TextEditingController();
  var valueController = TextEditingController();
  late PickedFile _image;
  final picker = ImagePicker();
  Map<String, String> resBank = {
    "A": "Boston",
    "B": "New York",
    "C": "Philadelphia",
    "D": "Cleveland",
    "E": "Richmond",
    "F": "Atlanta",
    "G": "Chicago",
    "H": "St. Louis",
    "I": "Minneapolis",
    "J": "Kansas City",
    "K": "Dallas",
    "L": "San Francisco"
  };

  Map<String, String> serYear = {
    "A": "1996",
    "B": "1999",
    "C": "2001",
    "D": "2003",
    "E": "2004",
    "F": "2003A",
    "G": "2004A",
    "H": "2006",
    "I": "2006",
    "J": "2009",
    "K": "2006A",
    "L": "2009A",
    "M": "2013",
    "N": "2017",
    "P": "2017A"
  };
  CollectionReference viewRef =
      FirebaseFirestore.instance.collection("Bills-Users-Customers");

  final regExp = RegExp(r'^([A-Z]|[A-Z]{2})(\s|)([0-9]{8})(\s|)([A-Z]?)$');

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
      SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  'Create Dollar Bill',
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
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: SingleChildScrollView(
                              child: Text("Functionalities & Features",
                                  textScaleFactor: 2.0),
                            ),
                            titleTextStyle: TextStyle(
                              fontFamily: "Raleway-SemiBold",
                              color: Colors.black,
                            ),
                            contentTextStyle: TextStyle(
                              fontFamily: "Raleway-Regular",
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "Hello\n",
                                    textScaleFactor: 1.8,
                                  ),
                                  Text(
                                    "If you have a photo on your phone, and you want to scan it, you can simply make a long press on the Camera Icon's below and it will open the gallery for you.",
                                    textScaleFactor: 1.8,
                                  ),
                                ],
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
                  },
                  icon: Icon(Icons.info_outline),
                ),
              ],
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              is1Checked = true;
                              is2Checked = false;
                              is5Checked = false;
                              is10Checked = false;
                              is20Checked = false;
                              is50Checked = false;
                              is100Checked = false;
                              valueController.text = "1";
                            });
                          },
                          child:
                              _dollarChecked(isChecked: is1Checked, value: 1),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              is2Checked = true;
                              is1Checked = false;
                              is5Checked = false;
                              is10Checked = false;
                              is20Checked = false;
                              is50Checked = false;
                              is100Checked = false;
                              valueController.text = "2";
                            });
                          },
                          child:
                              _dollarChecked(isChecked: is2Checked, value: 2),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              is5Checked = true;
                              is1Checked = false;
                              is2Checked = false;
                              is10Checked = false;
                              is20Checked = false;
                              is50Checked = false;
                              is100Checked = false;
                              valueController.text = "5";
                            });
                          },
                          child:
                              _dollarChecked(isChecked: is5Checked, value: 5),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              is10Checked = true;
                              is1Checked = false;
                              is2Checked = false;
                              is5Checked = false;
                              is20Checked = false;
                              is50Checked = false;
                              is100Checked = false;
                              valueController.text = "10";
                            });
                          },
                          child:
                              _dollarChecked(isChecked: is10Checked, value: 10),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              is20Checked = true;
                              is1Checked = false;
                              is2Checked = false;
                              is5Checked = false;
                              is10Checked = false;
                              is50Checked = false;
                              is100Checked = false;
                              valueController.text = "20";
                            });
                          },
                          child:
                              _dollarChecked(isChecked: is20Checked, value: 20),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              is50Checked = true;
                              is1Checked = false;
                              is2Checked = false;
                              is5Checked = false;
                              is10Checked = false;
                              is20Checked = false;
                              is100Checked = false;
                              valueController.text = "50";
                            });
                          },
                          child:
                              _dollarChecked(isChecked: is50Checked, value: 50),
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        is100Checked = true;
                        is1Checked = false;
                        is2Checked = false;
                        is5Checked = false;
                        is10Checked = false;
                        is20Checked = false;
                        is50Checked = false;
                        valueController.text = "100";
                      });
                    },
                    child: _dollarChecked(isChecked: is100Checked, value: 100),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[300]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              controller: serialNbController,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Icon(
                                    FontAwesomeIcons.dollarSign,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: MaterialButton(
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      getSerialNumber();
                                    },
                                    onLongPress: () {
                                      getSerialNumberGallery();
                                    },
                                  ),
                                ),
                                labelText: "Serial Number",
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 20 / scaleFactor,
                                  color: Colors.white,
                                  fontFamily: "Raleway-Regular"),
                              readOnly: true,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        MaterialButton(
                          // height: size.height*0.1,
                          height: 65,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onPressed: () async {
                            if (valueController.text.isEmpty ||
                                serialNbController.text.isEmpty) {
                              if (valueController.text.isEmpty) {
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
                                            "You need to specify the amount",
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
                                              "You need to provide the serial number",
                                              textScaleFactor: 1.4,),
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
                              final result =
                                  await Connectivity().checkConnectivity();
                              if (result == ConnectivityResult.wifi ||
                                  result == ConnectivityResult.mobile) {
                                viewRef
                                    .where("Serial Number",
                                        isEqualTo: serialNbController.text)
                                    .get()
                                    .then((value) {
                                  if (value.docs.length == 0) {
                                    List<String> splitList =
                                        serialNbController.text.split(" ");
                                    List<String> indexList = [];
                                    for (int i = 0; i < splitList.length; i++) {
                                      for (int j = 0;
                                          j < splitList[0].length + i;
                                          j++) {
                                        indexList
                                            .add(splitList[i].substring(0, j));
                                      }
                                    }
                                    if (valueController.text == "1" ||
                                        valueController.text == "2") {
                                      if (isNumeric(
                                              serialNbController.text[1]) ==
                                          true) {
                                        String year = "";
                                        if (valueController.text == "1")
                                          year = "1963";
                                        else
                                          year = "1976";
                                        DollarBill db = DollarBill(
                                          serialNb: serialNbController.text,
                                          reserveBank: resBank.containsKey(
                                                  serialNbController.text[0])
                                              ? resBank[
                                                  serialNbController.text[0]]
                                              : "Invalid Reserve Bank",
                                          amount: valueController.text,
                                        );
                                        viewRef.add({
                                          "Serial Number":
                                              serialNbController.text,
                                          "UserId": widget.userId,
                                          "CustId": widget.customer.id,
                                          "Search Index": indexList
                                        });

                                        widget.customer.reference
                                            .collection("Dollar Bills")
                                            .add({
                                          "Serial Number": db.serialNb,
                                          "Reserve Bank": db.reserveBank,
                                          "Amount": db.amount,
                                          "Series Year": year,
                                          "Date":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                        }).whenComplete(
                                                () => Navigator.pop(context));
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
                                                      "This Serial Number cannot be assigned to this amount ",textScaleFactor: 1.4,),
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
                                      if (isNumeric(
                                              serialNbController.text[1]) ==
                                          false) {
                                        DollarBill db = DollarBill(
                                            serialNb: serialNbController.text,
                                            reserveBank: resBank.containsKey(
                                                    serialNbController.text[1])
                                                ? resBank[
                                                    serialNbController.text[1]]
                                                : "Invalid Reserve Bank",
                                            amount: valueController.text,
                                            seriesYear:serYear.containsKey(
                                                serialNbController.text[0])
                                                ? serYear[
                                            serialNbController.text[0]]
                                                : "Invalid Series Year");
                                        viewRef.add({
                                          "Serial Number":
                                              serialNbController.text,
                                          "UserId": widget.userId,
                                          "CustId": widget.customer.id,
                                          "Search Index": indexList
                                        });
                                        widget.customer.reference
                                            .collection("Dollar Bills")
                                            .add({
                                          "Serial Number": db.serialNb,
                                          "Reserve Bank": db.reserveBank,
                                          "Amount": db.amount,
                                          "Series Year": db.seriesYear,
                                          "Date":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                                        }).whenComplete(
                                                () => Navigator.pop(context));
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
                                                      "This Serial Number cannot be assigned to this amount ",textScaleFactor: 1.4,),
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
                                    }
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 100,
                                            child: AlertDialog(
                                              contentTextStyle: TextStyle(
                                                fontFamily: "Raleway-Regular",
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12)),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        "This serial number already exist for another user.",textScaleFactor: 1.4),
                                                    Text("To add this serial number the owner of this bill should delete it.",textScaleFactor: 1.4)
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("OK")),
                                              ],
                                            ),
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
                              Icon(Icons.app_registration,
                                  color: Colors.white, size: 25),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      )
    ]);
  }

  Future getSerialNumber() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    String _text = '';
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print("No image selected");
      }
    });
    CircularProgressIndicator();
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_image.path));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        _text += (line.text! + '\n');
      }
    }
    List<String> str = _text.split("\n");
    print(_text);
    //String? serials=null;
    String temp = "";

    for (String s in str) {
      if (regExp.hasMatch(s)) {
        if (RegExp("[0-9]").hasMatch(s[s.length - 1])) {
          temp = s.replaceAll(" ", "") + "*";
        } else {
          temp = s.replaceAll(" ", "");
        }
        break;
      }
    }

    if (temp.isEmpty) {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:
              "Serial Number could not be captured properly please try again ",
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    } else {
      serialNbController.text = temp;
    }
  }

  Future getSerialNumberGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    String _text = '';
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print("No image selected");
      }
    });
    CircularProgressIndicator();
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_image.path));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        _text += (line.text! + '\n');
      }
    }
    print(_text);
    List<String> str = _text.split("\n");

    //String? serials=null;
    String temp = "";

    for (String s in str) {
      if (regExp.hasMatch(s)) {
        if (RegExp("[0-9]").hasMatch(s[s.length - 1])) {
          temp = s.replaceAll(" ", "") + "*";
        } else {
          temp = s.replaceAll(" ", "");
        }
        break;
      }
    }

    if (temp.isEmpty) {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:
              "Serial Number could not be captured properly please try again ",
        ),
      );
    } else {
      serialNbController.text = temp;
    }
  }

  Widget _dollarChecked({required bool isChecked, required int value}) {
    return Container(
      //width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            isChecked ? Color(0xff00741d).withOpacity(0.7) : Colors.transparent,
      ),
      child: Center(
        child: Text(
          "\$$value",
          textScaleFactor: 5.5,
          style: TextStyle(
            fontFamily: "serif",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
