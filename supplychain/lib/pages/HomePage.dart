// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import '../utils/appTheme.dart';
import '../services/supplyController.dart';
import 'package:supplychain/utils/Drawer.dart';
import 'package:supplychain/services/DatabaseService.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAppbarVisible = true;
  ScrollController _bodyScrollConroller = ScrollController();
  var userName = '';
  late var userSpecificButtonText = '';
  int subscribedSupplies = 0;
  late Route dashboardRoute;

  late SupplyController supplyController;
  // late List<Supply> allSupplies;
  @override
  void initState() {
    getDataOfUser(user.uid);
    dashboardRoute = routeToDashboard(context);
    super.initState();
    _bodyScrollConroller.addListener(() {
      setState(() {
        _isAppbarVisible = _bodyScrollConroller.offset <= 25;
      });
    });
  }

  void getDataOfUser(String uid) async {
    await DatabaseService().fetchDataOfUser(uid, 'type').then((res) {
          userType = res ?? "";
          getButtonText();
        }) ??
        "";
    email = await DatabaseService().fetchDataOfUser(uid, 'email') ?? "";
    userName = await DatabaseService().fetchDataOfUser(uid, 'name') ?? "";
    publicKey = await DatabaseService().fetchDataOfUser(uid, 'publicAddress') ??
        publicKey;
    String key =
        await DatabaseService().fetchDataOfUser(uid, 'privateAddress') ?? "";
    if (!key.contains("Error") && key.length == 66) {
      setState(() {
        privateKey = key;
        privateKeyLinked = true;
      });
    }

    setState(() {});
  }

  getButtonText() async {
    setState(() {
      userSpecificButtonText =
          userType == supplier ? 'Create Supply' : 'Explore Biofuels';
    });
  }

  int getSubScribedSupplies() {
    return supplyController.userSupply.length;
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    subscribedSupplies = supplyController.userSupply.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _isAppbarVisible
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                privateKeyLinked
                    ? Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor),
                          child: supplyController.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : Container(
                                  width: 33,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.primaryColor),
                                  child: Icon(
                                    Icons.notifications,
                                    size: 22,
                                  )),
                        ))
                    : SizedBox()
              ],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Biozen",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
        controller: _bodyScrollConroller,
        child: !privateKeyLinked
            ? AlertBoxForPrivateKeyError(
                user: user,
                name: userName,
                type: userType,
              )
            : Container(
                child: Stack(
                  alignment: Alignment.topCenter,
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
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(routeToProfile());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TileIconWithName(
                                      userProfileImage: user.photoURL,
                                      childText: "",
                                      context: context,
                                      route: routeToProfile(),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          userType,
                                          style: TextStyle(
                                            color: AppTheme.secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        // Container containing dashboard & refresh button
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TileIconWithName(
                                        icon: Icons.dashboard_rounded,
                                        childText: "Dashboard",
                                        gradient: AppTheme().themeGradient,
                                        route: dashboardRoute,
                                        context: context,
                                      ),
                                      TileIconWithName(
                                        icon: Icons.refresh_rounded,
                                        childText: "Refresh",
                                        gradient: AppTheme().themeGradient,
                                        context: context,
                                        supplyController: supplyController,
                                        // route: PageRouteBuilder(pageBuilder:
                                        //     (context, animation,
                                        //         secondaryAnimation) {
                                        //   return HomePage(
                                        //     user: thisUser!,
                                        //     name: userName,
                                        //     // userType: userType,
                                        //   );
                                        // }),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppTheme.secondaryDark,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(35),
                                          bottomRight: Radius.circular(35))),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${subscribedSupplies} Subscribed supplies",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "Checkout Dashboard for details",
                                        style: TextStyle(
                                          color: AppTheme.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Image.asset(
                                    'assets/fuel.png',
                                    scale: 3.5,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.38,
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.21,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.18),
                                    child: Column(
                                      children: [
                                        Text(
                                            "Biofuel hunt is now".toUpperCase(),
                                            style: TextStyle(fontSize: 19)),
                                        Text(
                                          "made easy".toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
      ),
      drawer: AppDrawer(
        type: userType,
      ),
      bottomSheet: privateKeyLinked
          ? GestureDetector(
              onTap: () async {
                if (userType == supplier) {
                  AlertBoxes.showAlertForCreateSupply(
                      context, supplyController);
                } else if (userType == fuelCompany) {
                  await displayAllOpenSupplies(context);
                } else {
                  print("aa gaya else mein");
                  Navigator.of(context).push(routeToDashboard(context));
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.3, bottom: 20),
                padding: EdgeInsets.symmetric(horizontal: 25),
                height: MediaQuery.of(context).size.height * 0.075,
                decoration: BoxDecoration(
                    gradient: AppTheme().themeGradient,
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.shadowColor,
                          blurRadius: 8,
                          spreadRadius: 1,
                          blurStyle: BlurStyle.normal)
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(90),
                        bottomLeft: Radius.circular(90))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userSpecificButtonText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_double_arrow_right_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 0,
                      ),
                    ]),
              ),
            )
          : SizedBox(),
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
    SupplyController? supplyController,
    Route? route,
    BuildContext? context,
    super.style,
  }) : super(
            onPressed: () {
              if (supplyController != null) {
                supplyController.getNotes();
                supplyController.getSuppliesOfUser();
                supplyController.notifyListeners();
              }
              if (route != null && context != null) {
                try {
                  Navigator.of(context).push(route);
                } catch (e) {
                  print("Route Exception : $e");
                }
              }
            },
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
                            : NetworkImage(userProfileImage),
                    child: icon != null
                        ? icon == Icons.refresh_rounded &&
                                supplyController != null &&
                                supplyController.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
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
