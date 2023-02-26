// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/Authentication.dart';
// import 'package:supplychain/utils/profilePage.dart';
// import 'package:supplychain/pages/dashnoard.dart';

class appDrawer extends StatefulWidget {
  final User _user;
  final String _userName;
  final String? userType;
  const appDrawer(
      {Key? key, required User user, required String name, String? type})
      : _user = user,
        _userName = name,
        userType = type,
        super(key: key);

  @override
  _appDrawerState createState() => _appDrawerState();
}

class _appDrawerState extends State<appDrawer> {
  bool _isSigningOut = false;
  User? _thisUser;
  var userName, userType;

  @override
  void initState() {
    _thisUser = widget._user;
    userName = widget._userName;
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
                      backgroundImage: _thisUser!.photoURL == null
                          ? NetworkImage(
                              "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png")
                          : NetworkImage(_thisUser!.photoURL!),
                    ),
                    accountName: Text(
                      userName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(_thisUser!.email ?? "Link Your Email !"),
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
                          MaterialStateProperty.all(Colors.indigo.shade700)),
                  onPressed: () {
                    Navigator.of(context)
                        .push(routeToProfile(_thisUser!, userName, userType));
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
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo.shade700)),
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
                          MaterialStateProperty.all(Colors.indigo.shade700)),
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
                      backgroundColor: MaterialStateProperty.all(
                          Colors.deepPurple.shade400)),
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
