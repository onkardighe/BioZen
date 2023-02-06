import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'utils/appTheme.dart';

class HomePage extends StatefulWidget {
  final User _user;
  const HomePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? thisUser;
  var myData = [
    {
      "fName": "Onkar",
      "lName": "Dighe",
    },
    {
      "fName": "Nadim",
      "lName": "Shah",
    },
    {
      "fName": "Om",
      "lName": "Kshirsagar",
    },
    {
      "fName": "Mohit",
      "lName": "Ahire",
    },
    {
      "fName": "Shri",
      "lName": "subramaniam",
    }
  ];

  @override
  void initState() {
    thisUser = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications_active),
          )
        ],
        title: const Text(
          "Suppy Chain",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                      gradient: AppTheme().themeGradient,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TileIconWithName(
                              userProfileImage: thisUser!.photoURL,
                              childText: "",
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              thisUser!.displayName!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                blurStyle: BlurStyle.normal)
                          ],
                          borderRadius: BorderRadius.circular(35)),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(25),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(),
                            child: Text(
                              "text",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TileIconWithName(
                                  icon: Icons.dashboard_rounded,
                                  childText: "Dashboard",
                                  gradient: AppTheme().themeGradient,
                                ),
                                TileIconWithName(
                                  icon: Icons.history_rounded,
                                  childText: "History",
                                  gradient: AppTheme().themeGradient,
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Column(children: [
                      for (var thisData in myData) buildCard(thisData["fName"])
                    ]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  Container buildCard(String? str) {
    return Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black26, blurRadius: 10, blurStyle: BlurStyle.normal)
      ], color: Colors.white, borderRadius: BorderRadius.circular(90)),
      child: Text(
        "${str}",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class TileIconWithName extends TextButton {
  TileIconWithName({
    super.key,
    IconData? icon,
    String? userProfileImage = "",
    String? childText = "",
    LinearGradient? gradient,
    super.style,
  }) : super(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration:
                      BoxDecoration(gradient: gradient, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    backgroundImage: userProfileImage == ""
                        ? null
                        : NetworkImage(userProfileImage!),
                    child: icon != null
                        ? Icon(
                            icon,
                            size: 40,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                  ),
                ),
                childText == null
                    ? const SizedBox(
                        height: 0,
                      )
                    : const SizedBox(
                        height: 10,
                      ),
                Container(
                  child: childText == ""
                      ? null
                      : Text(
                          childText!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                )
              ],
            ));
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
