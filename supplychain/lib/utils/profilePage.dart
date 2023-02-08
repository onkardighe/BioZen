import 'package:flutter/material.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final User _user;
  final userName, userType;
  const ProfilePage({
    Key? key,
    required String name,
    required String type,
    required User user,
  })  : userName = name,
        userType = type,
        _user = user,
        super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userName, userType;
  User? _thisUser;

  @override
  void initState() {
    userName = widget.userName;
    _thisUser = widget._user;
    userType = widget.userType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue.shade600),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                  // size: 33,
                  size: 23,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: AppTheme().themeGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Spacer(),
                  CircleAvatar(
                    radius: 50.0,
                    // backgroundImage: AssetImage('images/photo_shirt.jpg'),
                    backgroundImage: _thisUser!.photoURL != null
                        ? NetworkImage(_thisUser!.photoURL!)
                        : NetworkImage(
                            "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png"),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    this.userType,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 20,
                      color: Colors.teal[100],
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: Divider(
                      color: Colors.teal[100],
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.deepPurple,
                      ),
                      // trailing: Icon(
                      //   Icons.edit,
                      //   size: 17,
                      //   color: Colors.deepPurple,
                      // ),
                      title: Text(
                        _thisUser!.phoneNumber == null
                            ? "Link Mobile Number ! "
                            : _thisUser!.phoneNumber!,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.deepPurple,
                      ),
                      // trailing: Icon(
                      //   Icons.edit,
                      //   size: 17,
                      //   color: Colors.deepPurple,
                      // ),
                      title: Text(
                        _thisUser!.email ?? "Email Not Found !!",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: Divider(
                      color: Colors.teal[100],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
