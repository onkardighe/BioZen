// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:supplychain/utils/constants.dart';
// import 'package:supplychain/utils/profilePage.dart';
// import 'package:supplychain/pages/dashnoard.dart';

class appDrawer extends StatefulWidget {
  final String? userType;
  const appDrawer({Key? key, String? type})
      : userType = type,
        super(key: key);

  @override
  _appDrawerState createState() => _appDrawerState();
}

class _appDrawerState extends State<appDrawer> {
  bool _isSigningOut = false;
  var userType;

  @override
  void initState() {
    userType = widget.userType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(gradient: AppTheme().themeGradient),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 210,
                child: DrawerHeader(
                  child: UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(bottom: 0),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: user.photoURL == null
                          ? NetworkImage(
                              "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png")
                          : NetworkImage(user.photoURL!),
                    ),
                    accountName: Text(
                      user.displayName!,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(email),
                    decoration: BoxDecoration(color: Colors.transparent),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(AppTheme.primaryDark)),
                  onPressed: () {
                    Navigator.of(context).push(routeToProfile());
                  },
                  child: const ListTile(
                    textColor: Colors.white,
                    title: Text(
                      "Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Icon(
                      Icons.person_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(AppTheme.primaryDark)),
                  onPressed: () {
                    Navigator.of(context).push(routeToDashboard(context));
                  },
                  child: const ListTile(
                    textColor: Colors.white,
                    title: Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Icon(
                      Icons.dashboard_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(AppTheme.primaryDark)),
                  onPressed: () {},
                  child: const ListTile(
                    textColor: Colors.white,
                    title: Text(
                      "Settings",
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Icon(
                      Icons.settings,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 200, left: 20, right: 20, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(AppTheme.secondaryDark)),
                  onPressed: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await Authentication.signOut(context: context);
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        routeToLogInScreen(), (Route route) => false);
                  },
                  child: const ListTile(
                    textColor: Colors.white,
                    title: Text(
                      "Logout",
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Icon(
                      Icons.settings,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
