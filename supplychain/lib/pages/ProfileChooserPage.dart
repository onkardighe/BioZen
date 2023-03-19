// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/utils/constants.dart';

class ProfileChooserPage extends StatefulWidget {
  final User _user;
  const ProfileChooserPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  @override
  _ProfileChooserPageState createState() => _ProfileChooserPageState();
}

class _ProfileChooserPageState extends State<ProfileChooserPage> {
  double _cardHeight = 220, _cardWidth = 160;
  User? _thisUser;
  var userType;

  @override
  void initState() {
    _thisUser = widget._user;
    getType();
    if (userType != null) {
      _routeToHomeScreen(userType);
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
            children: [
              Spacer(),
              Text(
                "Are You ?",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileCard(Icons.factory_rounded, supplier),
                  SizedBox(width: 20),
                  profileCard(Icons.local_gas_station_rounded, fuelCompany),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileCard(Icons.local_shipping_rounded, transportAuthority),
                  SizedBox(width: 20),
                  profileCard(
                    Icons.shield_rounded,
                    insuranceAuthority,
                  ),
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard(IconData icon, String type) {
    return SizedBox.fromSize(
      size: Size(_cardWidth, _cardHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Material(
          color: Colors.blueGrey.shade100,
          child: InkWell(
            splashColor: AppTheme.primaryColor, // splash color
            onTap: () {
              Authentication.updateUserType(_thisUser!.uid, type);

              _routeToHomeScreen(type);
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Icon(
                  icon,
                  size: 80,
                ),
                Text(
                  type,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _routeToHomeScreen(String type) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(
          ),
        ),
        (Route route) => false);
  }
}
