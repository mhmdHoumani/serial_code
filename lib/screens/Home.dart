import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:senior_project/screens/CreateNewCustomer.dart';
import 'package:senior_project/screens/CustomerDetails.dart';
import 'package:senior_project/screens/CustomerInfo.dart';
import 'package:senior_project/screens/SearchCustomer.dart';
import 'package:senior_project/screens/UpdateCustomer.dart';
import 'package:senior_project/screens/UpdateUser.dart';
import 'package:senior_project/screens/UserInfo.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../StyleTXT.dart';
import 'Login.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late var id = widget.userId;
  CollectionReference userRef = FirebaseFirestore.instance.collection("Users");
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Stack(children: [
      BackGroundImage(
        image:
            "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg",
      ),
      SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: MediaQuery.of(context).size.width * 0.28,
            centerTitle: true,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "Functionalities & Features",
                                textScaleFactor: 2.0,
                              ),
                            ),
                            titleTextStyle: TextStyle(
                              fontFamily: "Raleway-SemiBold",
                              color: Colors.black,
                            ),
                            contentTextStyle: TextStyle(
                              fontFamily: "Raleway-Regular",
                              color: Colors.black,
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Welcome\n",
                                    textScaleFactor: 1.8,
                                  ),
                                  Text(
                                    "We're here to help you in the functionalities & features of our application.\n",
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "▪ To see each customer's bills, you just need to click on any customer you have.\n",
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "▪ To see your customers information, double click on any one of them and it will appear.\n",
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "▪ To delete one of your customers, a long press on him is enough to apply it.\n",
                                    textScaleFactor: 1.5,
                                  ),
                                  Text(
                                    "Note: The long click functionality also work on each bill you have.\n",
                                    textScaleFactor: 1.6,
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
                  icon: Icon(
                    Icons.info_outlined,
                  ),
                ),
                IconButton(
                  constraints: BoxConstraints(
                    minWidth: 0,
                  ),
                  onPressed: () async {
                    DocumentSnapshot user = await userRef.doc(id).get();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserInfo(
                                  userId: user,
                                )));
                  },
                  icon: Icon(Icons.update),
                ),
              ],
            ),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                'Home Page',
                textScaleFactor: 1.5,
                style: titleStyleTXT,
              ),
            ),
            actions: [
              Container(
                width: MediaQuery.of(context).size.width * 0.24,
                child: IconButton(
                  onPressed: () async {
                    userRef.doc(id).update({"isLoggedIn": false});
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setBool('isLogged', false);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Logout",
                          textScaleFactor: 0.8,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "serif",
                              color: Colors.white)),
                      Icon(Icons.logout, size: 20),
                    ],
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "btnSearch",
                backgroundColor: Colors.green.shade700,
                child: Icon(
                  Icons.search,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () async {
                  DocumentSnapshot user = await userRef.doc(id).get();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchCustomer(
                                user: user,
                              )));
                },
              ),
              SizedBox(width: 15),
              FloatingActionButton(
                heroTag: "btnAdd",
                backgroundColor: Colors.green.shade700,
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNewCustomer(
                                userId: id,
                              )));
                },
              ),
            ],
          ),
          body: Container(
            margin: EdgeInsets.all(12),
            child: StreamBuilder(
                stream: userRef.doc(id).collection("Customers").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                      itemCount:
                          snapshot.hasData ? snapshot.data!.docs.length : 0,
                      itemBuilder: (context, index) {
                        RandomColor _randomColor = RandomColor();
                        ColorHue _green = ColorHue.custom(Range(80, 90));
                        Color _color =
                            _randomColor.randomColor(colorHue: _green);
                        return GestureDetector(
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
                                            "Are You Sure you want to delete this customer?",
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
                                            var snapshots = snapshot
                                                .data!.docs[index].reference
                                                .collection("Dollar Bills")
                                                .get();
                                            await snapshots.then((value) =>
                                                value.docs.forEach((element) {
                                                  element.reference.delete();
                                                }));
                                            CollectionReference cust =
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        "Bills-Users-Customers");
                                            cust
                                                .where("CustId",
                                                    isEqualTo: snapshot
                                                        .data!.docs[index].id)
                                                .get()
                                                .then((value) => value.docs
                                                        .forEach((element) {
                                                      element.reference
                                                          .delete();
                                                    }));
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
                          onDoubleTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerInfo(
                                        userId: widget.userId,
                                        customer: snapshot.data!.docs[index])));
                          },
                          onTap: () {
                            print(snapshot.data!.docs[index].id);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerDetails(
                                          customer: snapshot.data!.docs[index],
                                          userId: widget.userId,
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: _color.withOpacity(0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Shimmer(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data!.docs[index]["First Name"],
                                    textScaleFactor: 2.0,
                                    style: customerStyleTXT,
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]["Last Name"],
                                    textScaleFactor: 1.5,
                                    style: customerStyleTXT,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) {
                        return StaggeredTile.count(1, index.isEven ? 1 : 1.4);
                      });
                }),
          ),
        ),
      ),
    ]);
  }
}
