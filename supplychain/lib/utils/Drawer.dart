import 'package:flutter/material.dart';
import 'package:supplychain/pages/utilPages/InsurancePoliciesInputs.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:supplychain/utils/constants.dart';

class AppDrawer extends StatefulWidget {
  final String? userType;
  const AppDrawer({Key? key, String? type})
      : userType = type,
        super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isSigningOut = false;
  var userType, userName = '';

  @override
  void initState() {
    userType = widget.userType;
    getUserData(user.uid);
    super.initState();
  }

  getUserData(String uid) async {
    if (user.displayName != null) {
      userName = user.displayName!;
    } else {
      print("getting from DB");
      userName = await DatabaseService().fetchDataOfUser(uid, 'name') ?? "";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(gradient: AppTheme().themeGradient),
          child: Column(
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
                      userName,
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
              userType != insuranceAuthority
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90),
                            )),
                            backgroundColor: MaterialStateProperty.all(
                                AppTheme.primaryDark)),
                        onPressed: () {
                          if (userType == insuranceAuthority) {
                            Navigator.push(context, PageRouteBuilder(
                                pageBuilder:
                                    ((context, animation, secondaryAnimation) {
                              return InsurancePoliciesInput();
                            })));
                          }
                        },
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
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                      Icons.logout,
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
