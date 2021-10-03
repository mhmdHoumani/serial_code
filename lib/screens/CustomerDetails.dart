import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/screens/CreateDollarBill.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomerDetails extends StatefulWidget {
  final DocumentSnapshot customer;
  final String userId;

  CustomerDetails({required this.customer, required this.userId});

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Stack(
      children: [
        BackGroundImage(
          image:
              "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg",
        ),
        SafeArea(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                backgroundColor: Colors.transparent,
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green.shade700,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateDollarBill(
                                customer: widget.customer,
                                userId: widget.userId,
                              )));
                },
              ),
              body: StreamBuilder(
                stream: widget.customer.reference
                    .collection("Dollar Bills")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView.builder(
                      itemCount:
                          snapshot.hasData ? snapshot.data!.docs.length : 0,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                            child: GestureDetector(
                          onLongPress: () {
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
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            size: 60,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                              "Are You Sure you want to delete this bill?",
                                              textScaleFactor: 1.4,

                                              ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          final result = await Connectivity()
                                              .checkConnectivity();
                                          if (result ==
                                                  ConnectivityResult.wifi ||
                                              result ==
                                                  ConnectivityResult.mobile) {
                                            FirebaseFirestore.instance
                                                .collection(
                                                    "Bills-Users-Customers")
                                                .where("Serial Number",
                                                    isEqualTo: snapshot
                                                            .data!.docs[index]
                                                        ["Serial Number"])
                                                .get()
                                                .then((value) {
                                              value.docs.forEach((element) {
                                                element.reference.delete();
                                              });
                                            });

                                            snapshot.data!.docs[index].reference
                                                .delete();
                                            Navigator.pop(context);
                                          } else {
                                            showTopSnackBar(
                                              context,
                                              CustomSnackBar.error(
                                                message:
                                                    "You don't have internet access",
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          "OK",
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            height: 2 * MediaQuery.of(context).size.width / 5,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/${snapshot.data!.docs[index]["Amount"]}dollarbill.jpg"),
                                  fit: BoxFit.fill,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black45, BlendMode.hardLight),
                                )),
                            child: Shimmer(
                              duration: Duration(
                                seconds: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Amount : " +
                                        snapshot.data!.docs[index]["Amount"],
                                    style: dollarDetailsTXT,
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "Reserve Bank : " +
                                        snapshot.data!.docs[index]
                                            ["Reserve Bank"],
                                    style: dollarDetailsTXT,
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "Serial Number : " +
                                        snapshot.data!.docs[index]
                                            ["Serial Number"],
                                    style: dollarDetailsTXT,
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "Series Year : " +
                                        snapshot.data!.docs[index]
                                            ["Series Year"],
                                    style: dollarDetailsTXT,
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "Date : ${snapshot.data!.docs[index]["Date"]}",
                                    style: dollarDetailsTXT,
                                    textScaleFactor: 1.5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
                      });
                },
              )),
        )
      ],
    );
  }
}
