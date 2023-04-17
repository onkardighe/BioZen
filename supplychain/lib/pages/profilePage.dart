// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName = '', userType = '';
  var _mobileLinkController = TextEditingController();
  var _privateAddressController = TextEditingController();
  var isMobileLinked = true;
  var number = '';
  var isPrivateAddressLinked = false;
  var privateWalletAddress = '';
  late String? publicWalletAddress = '';
  var copyIcon = Icon(Icons.copy_rounded);
  num ratings = 0.0;

  @override
  void initState() {
    getDataOfUser(user.uid);
    checkMobileLink(user.uid);
    checkPrivateAddressLink(user.uid);
    super.initState();
  }

  void getDataOfUser(String uid) async {
    if (user.displayName != null) {
      userName = user.displayName!;
    } else {
      userName = await DatabaseService().fetchDataOfUser(uid, 'name') ?? "";
    }

    userType = await DatabaseService().fetchDataOfUser(uid, 'type') ?? "";
    privateKey =
        await DatabaseService().fetchDataOfUser(uid, 'privateAddress') ?? "";
    await DatabaseService()
        .fetchDataOfUser(uid, 'publicAddress')
        .then((address) async {
      if (address != null && !address.contains("Error")) {
        publicWalletAddress = address;
        await DatabaseService.getRating(address: address).then((res) {
          print(" type : ${res.runtimeType}");
          ratings = res;
        });
      }
    });

    if (this.mounted) {
      setState(() {});
    }
  }

  void checkMobileLink(String uid) async {
    isMobileLinked = await Authentication.isMobileLinked(uid);

    if (isMobileLinked) {
      number = await DatabaseService.getMobileNumber(uid);
    }
    setState(() {});
  }

  void checkPrivateAddressLink(String uid) async {
    isPrivateAddressLinked = await Authentication.isPrivateKeyAdded(uid);
    if (isPrivateAddressLinked) {
      privateWalletAddress =
          await DatabaseService().fetchDataOfUser(uid, 'privateAddress') ?? "";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () {
          return Navigator.pushAndRemoveUntil(
                  context, routeToHomePage(context), (route) => false)
              as Future<bool>;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: Container(
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        routeToHomePage(context),
                        (Route<dynamic> route) => false);
                  },
                  child: Icon(
                    Icons.arrow_circle_left_rounded,
                    color: Colors.white,
                    size: 36,
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
              child: Column(
                children: [
                  Spacer(),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png"),
                  ),
                  SizedBox(height: 10.0),
                  // ------------------- NAME ----------------------------------
                  Text(
                    userName,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.clip),
                  ),
                  // ------------------- TYPE ----------------------------------
                  Text(
                    this.userType,
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      fontSize: 20,
                      color: AppTheme.secondaryColor,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: Divider(
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  // ------------------- RATINGS ----------------------------------
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: getStarListFromRatings(ratings, 30.0),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: Divider(
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.phone_android_rounded,
                          color: AppTheme.primaryColor,
                        ),
                        title: isMobileLinked
                            ? Text(
                                number,
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          showAlert();
                                        },
                                        child: Text("Link Mobile Number !",
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                            ))),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(
                        email,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
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
                        Icons.medical_information_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                            text: publicWalletAddress ?? "",
                          ));
                          setState(() {
                            copyIcon = Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                            );
                          });
                        },
                        child: copyIcon,
                      ),
                      title: Text(
                        publicWalletAddress != null &&
                                publicWalletAddress!.trim().isNotEmpty
                            ? "${publicWalletAddress!.substring(0, 8)}*************${publicWalletAddress!.substring(publicWalletAddress!.length - 5, publicWalletAddress!.length)} "
                            : "User Not Found !!",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    // card for Private key
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.key_rounded,
                          color: privateKeyLinked
                              ? AppTheme.primaryColor
                              : Colors.red,
                        ),
                        title: isPrivateAddressLinked
                            ? Text(
                                privateWalletAddress.trim().isNotEmpty
                                    ? privateWalletAddress.length <= 8
                                        ? privateWalletAddress
                                        : "${privateWalletAddress.substring(0, 8)}*************${privateWalletAddress.substring(privateWalletAddress.length - 5, privateWalletAddress.length)} "
                                    : "User Not Found !!",
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          showAlertForPrivateAddress();
                                        },
                                        child: Text(
                                            "Enter Wallet Private Address !",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ))),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              )),
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: Divider(
                      color: AppTheme.secondaryColor,
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

  _linkMobileNumber() async {
    if (_mobileLinkController.value.text.length != 10) {
      print("Length not correct");
      return;
    }

    var completeNumber = "+91" + _mobileLinkController.value.text;
    await DatabaseService.setMobileNumber(user.uid, completeNumber);
    setState(() {
      number = completeNumber;
      isMobileLinked = true;
      mobileNumber = number;
      Navigator.of(context).pop();
    });
  }

  _linkPrivateAddress() async {
    var address = "0x" + _privateAddressController.value.text.trim();

    if (address.length != 66) {
      print("Address not correct");
      return;
    }

    await DatabaseService.setPrivateAddress(user.uid, address);
    setState(() {
      privateWalletAddress = address;
      isPrivateAddressLinked = true;
      privateKeyLinked = true;
      privateKey = address;
      Navigator.of(context).pop();
    });
  }

  TextFormField gettextForMobile() {
    return TextFormField(
      onEditingComplete: () => _linkMobileNumber(),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      controller: _mobileLinkController,
      style: TextStyle(color: AppTheme.primaryColor),
      decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor)),
          label: Text(
            "Mobile",
            style: TextStyle(color: AppTheme.primaryColor),
          )),
    );
  }

  TextFormField gettextForPrivateAddress() {
    return TextFormField(
      // onEditingComplete: () => _linkMobileNumber(),
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [
        LengthLimitingTextInputFormatter(66),
      ],
      controller: _privateAddressController,
      style: TextStyle(color: AppTheme.primaryColor),
      decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor)),
          label: Text(
            "Wallet Private Address",
            style: TextStyle(color: AppTheme.primaryColor),
          )),
    );
  }

  Future<void> showAlertForPrivateAddress() async {
    showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeInOut.transform(animation.value);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomCenter,
            child: child,
          );
        },
        pageBuilder: (BuildContext context, animation, secondaryAnimation) {
          return AlertDialog(
            title: Text(
              "Enter Private Address",
              style: TextStyle(color: AppTheme.primaryColor),
            ),
            content: gettextForPrivateAddress(),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                    AppTheme.primaryColor,
                  )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.primaryColor)),
                  onPressed: () {
                    _linkPrivateAddress();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }

  Future<void> showAlert() async {
    showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeInOut.transform(animation.value);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: child,
          );
        },
        pageBuilder: (BuildContext context, animation, secondaryAnimation) {
          return AlertDialog(
            title: Text(
              "Enter Mobile Number",
              style: TextStyle(color: AppTheme.primaryColor),
            ),
            content: gettextForMobile(),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                    AppTheme.primaryColor,
                  )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.primaryColor)),
                  onPressed: () {
                    _linkMobileNumber();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }
}
