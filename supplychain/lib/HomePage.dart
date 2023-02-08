import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/appTheme.dart';
import 'package:supplychain/utils/appDrawer.dart';
import 'package:supplychain/utils/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final User _user;
  final String _userName;
  String _userType;

  HomePage({
    Key? key,
    required User user,
    required name,
    String userType = '',
  })  : _user = user,
        _userName = name,
        _userType = userType,
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAppbarVisible = true;
  ScrollController _bodyScrollConroller = ScrollController();
  var initial;
  User? thisUser;
  var userName = '', userType = '';
  var myData = [
    {
      "fName": "Onkar",
      "lName": "Dighe",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Nadim",
      "lName": "Shah",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Om",
      "lName": "Kshirsagar",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "DhirajKumar",
      "lName": "Sonawane",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Mohit",
      "lName": "Ahire",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Shri",
      "lName": "subramaniam",
      "time": "01:00 PM",
      "date": "22/02/2022",
    }
  ];

  @override
  void initState() {
    thisUser = widget._user;
    super.initState();
    getType();

    _bodyScrollConroller.addListener(() {
      setState(() {
        _isAppbarVisible = _bodyScrollConroller.offset <= 25;
      });
    });
  }

  void getType() async {
    userType = await DatabaseService().getType(widget._user.uid) ?? "";
    userName = await DatabaseService().getName(widget._user.uid) ?? "";
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _isAppbarVisible
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Container(
                        width: 33,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.indigo.shade400),
                        child: Icon(
                          Icons.notifications,
                          size: 22,
                        )),
                  )
                ],
                title: Text(
                  "Suppy Chain",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        body: SingleChildScrollView(
          controller: _bodyScrollConroller,
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
                                userName,
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
                                // "Total supplies subscribed : ${myData.length}",
                                "Type : ${userType}",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                        for (var thisData in myData)
                          buildCard(thisData["fName"], myData.indexOf(thisData),
                              thisData["date"], thisData["time"])
                      ]),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: appDrawer(
          user: thisUser!,
          name: thisUser!.displayName ?? userName,
          type: userType,
        ));
  }

  Widget buildCard(String? str, int id, String? date, String? time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          // padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 85,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                blurStyle: BlurStyle.normal)
          ], color: Colors.white, borderRadius: BorderRadius.circular(90)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                    gradient: AppTheme().themeGradient, shape: BoxShape.circle),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.calculate_rounded,
                    size: 45,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Package id : ${id}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${str}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 75,
                width: 120,
                decoration: BoxDecoration(
                    gradient: AppTheme().themeGradient,
                    borderRadius: BorderRadius.circular(90)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(time!, style: TextStyle(color: Colors.white)),
                      Container(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Text(
                        date!,
                        style: TextStyle(color: Colors.white),
                      )
                    ]),
              )
            ],
          ),
        ),
      ],
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
                        : userProfileImage == null
                            ? NetworkImage(
                                "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png")
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
