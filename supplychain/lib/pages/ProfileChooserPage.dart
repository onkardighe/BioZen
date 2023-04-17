// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/utils/constants.dart';

class ProfileChooserPage extends StatefulWidget {
  final User _user;
  static double _cardHeight = 180, _cardWidth = 120;

  const ProfileChooserPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  @override
  _ProfileChooserPageState createState() => _ProfileChooserPageState();

  static void _routeToHomeScreen(BuildContext context, String type) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
        (Route route) => false);
  }
}

class _ProfileChooserPageState extends State<ProfileChooserPage> {
  double _cardHeight = 100, _cardWidth = 140;
  User? _thisUser;
  var userType;

  @override
  void initState() {
    _thisUser = widget._user;
    getType();
    if (userType != null) {
      ProfileChooserPage._routeToHomeScreen(context, userType);
      return;
    }
    super.initState();
  }

  void getType() async {
    userType =
        await DatabaseService().fetchDataOfUser(widget._user.uid, 'type') ?? "";
    if (this.mounted) {
      setState(() {});
    }
  }

  updateUser(String type) {
    setState(() {
      userType = type;
    });
  }

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppTheme().themeGradient)),
        centerTitle: true,
        title: const Text(
          "Supply Chain",
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Are You ?",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              Text("$userType",
                  style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileCard(
                    icon: Icons.factory_rounded,
                    type: supplier,
                    callbackToUpdateUser: updateUser,
                  ),
                  SizedBox(width: 20),
                  ProfileCard(
                      icon: Icons.local_gas_station_rounded,
                      type: fuelCompany,
                      callbackToUpdateUser: updateUser),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileCard(
                      icon: Icons.local_shipping_rounded,
                      type: transportAuthority,
                      callbackToUpdateUser: updateUser),
                  SizedBox(width: 20),
                  ProfileCard(
                      icon: Icons.shield_rounded,
                      type: insuranceAuthority,
                      callbackToUpdateUser: updateUser),
                ],
              ),
              SizedBox(
                height: 35,
              ),
              GestureDetector(
                onTap: () async {
                  Authentication.updateUserType(user.uid, userType);

                  if (userType == insuranceAuthority) {
                    var policies =
                        await DatabaseService.getPolicies(uid: user.uid);

                    if (policies.length == 0) {
                      AlertBoxes.createPolicyAlertBox(
                          context: context, callback: updateState);
                    } else {
                      ProfileChooserPage._routeToHomeScreen(context, userType);
                    }
                  } else {
                    ProfileChooserPage._routeToHomeScreen(context, userType);
                  }
                },
                child: Container(
                    child: Icon(
                      Icons.arrow_circle_right,
                      size: 55,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              blurStyle: BlurStyle.normal)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  Function callbackToUpdateUser;
  final IconData _icon;
  final String _type;
  ProfileCard(
      {super.key,
      required IconData icon,
      required String type,
      required Function this.callbackToUpdateUser})
      : _type = type,
        _icon = icon;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late IconData icon;
  late String type;

  @override
  void initState() {
    icon = widget._icon;
    type = widget._type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          userType = type;
          widget.callbackToUpdateUser(type);
        });
      },
      child: Container(
        width: 130,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: type == userType
                ? AppTheme.primaryColor
                : Colors.blueGrey.shade100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Icon(
              icon,
              size: 60,
              color: type == userType ? Colors.white : null,
            ),
            Text(
              type,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: type == userType ? Colors.white : null,
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
