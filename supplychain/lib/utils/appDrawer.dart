import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/LogInPage.dart';
import 'package:supplychain/utils/Authentication.dart';

class appDrawer extends StatefulWidget {
  final User _user;
  final String _userName;
  const appDrawer({Key? key, required User user, required String name})
      : _user = user,
        _userName = name,
        super(key: key);

  @override
  _appDrawerState createState() => _appDrawerState();
}

class _appDrawerState extends State<appDrawer> {
  bool _isSigningOut = false;
  User? _thisUser;
  var userName;

  @override
  void initState() {
    _thisUser = widget._user;
    userName = widget._userName;
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
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: _thisUser!.photoURL == null
                        ? NetworkImage(
                            "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png")
                        : NetworkImage(_thisUser!.photoURL!),
                  ),
                  accountName: Text(
                    _thisUser!.displayName != null
                        ? _thisUser!.displayName!
                        : userName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(_thisUser!.email!),
                  decoration: BoxDecoration(color: Colors.transparent),
                )),
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
                      "Edit Profile",
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Icon(
                      Icons.edit_outlined,
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
                        _routeToLogInScreen(), (Route route) => false);
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

  Route _routeToLogInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LogInPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
