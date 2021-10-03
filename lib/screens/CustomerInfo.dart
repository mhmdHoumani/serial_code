import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senior_project/StyleTXT.dart';
import 'package:senior_project/screens/UpdateCustomer.dart';
import 'package:senior_project/shared/BackgroundImage.dart';
import 'package:senior_project/shared/TextFormFieldWidget.dart';

class CustomerInfo extends StatefulWidget {
  final DocumentSnapshot customer;
  final String userId;

  CustomerInfo({required this.customer, required this.userId});

  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  var firstname = TextEditingController();
  var lastname = TextEditingController();
  var phoneNbr = TextEditingController();
  var nationality = TextEditingController();
  var address = TextEditingController();
  var gender = TextEditingController();

  @override
  void initState() {
    firstname = TextEditingController(text: widget.customer.get("First Name"));
    lastname =
        TextEditingController(text: "${widget.customer.get("Last Name")}");
    phoneNbr =
        TextEditingController(text: "${widget.customer.get("Phone Number")}");
    nationality =
        TextEditingController(text: "${widget.customer.get("Country")}");
    address = TextEditingController(text: "${widget.customer.get("Address")}");
    gender = TextEditingController(text: "${widget.customer.get("Gender")}");

    super.initState();
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
                "assets/100 Dollar Bills IPhone Wallpaper - IPhone Wallpapers.jpeg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Customer's Info",
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
                  child: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getDefaultTextFormField(
                                  isReadable: true,
                                  obscure: false,
                                  lblText: 'First Name',
                                  txtInputAction: TextInputAction.next,
                                  textEditingController: firstname,
                                  type: TextInputType.text,
                                  style: fontStyle,
                                  iconData: FontAwesomeIcons.user),
                              getDefaultTextFormField(
                                isReadable: true,
                                obscure: false,
                                iconData: FontAwesomeIcons.user,
                                lblText: 'Last Name',
                                style: fontStyle,
                                txtInputAction: TextInputAction.next,
                                textEditingController: lastname,
                                type: TextInputType.text,
                              ),
                              getDefaultTextFormField(
                                isReadable: true,
                                obscure: false,
                                iconData: FontAwesomeIcons.flag,
                                lblText: 'Country',
                                style: fontStyle,
                                txtInputAction: TextInputAction.next,
                                textEditingController: nationality,
                              ),
                              getDefaultTextFormField(
                                isReadable: true,
                                obscure: false,
                                iconData: FontAwesomeIcons.phoneAlt,
                                lblText: 'Phone Number',
                                txtInputAction: TextInputAction.next,
                                style: fontStyle,
                                textEditingController: phoneNbr,
                                type: TextInputType.phone,
                              ),
                              getDefaultTextFormField(
                                isReadable: true,
                                obscure: false,
                                iconData: FontAwesomeIcons.addressCard,
                                lblText: 'Address',
                                txtInputAction: TextInputAction.next,
                                style: fontStyle,
                                type: TextInputType.text,
                                textEditingController: address,
                              ),
                              getDefaultTextFormField(
                                isReadable: true,
                                obscure: false,
                                iconData: FontAwesomeIcons.addressCard,
                                lblText: 'Gender',
                                style: fontStyle,
                                txtInputAction: TextInputAction.next,
                                type: TextInputType.text,
                                textEditingController: gender,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                              builder: (context) => UpdateCustomer(
                                    userId: widget.userId,
                                    customer: widget.customer,
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
                        Icon(Icons.update, size: 25, color: Colors.white),
                      ],
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
}
