// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/services/Authentication.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/utils/constants.dart';

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
  var _mobileLinkController = TextEditingController();
  var _privateAddressController = TextEditingController();
  var isMobileLinked = true;
  var number = '';
  var isPrivateAddressLinked = false;
  var privateWalletAddress = '';
  late String? publicWalletAddress = '';
  var copyIcon = Icon(Icons.copy_rounded);

  @override
  void initState() {
    userName = widget.userName;
    _thisUser = widget._user;
    userType = widget.userType;
    getDataOfUser();
    super.initState();
    checkMobileLink();
    checkPrivateAddressLink();
  }

  void getDataOfUser() async {
    userType =
        await DatabaseService().fetchDataOfUser(widget._user.uid, 'type') ?? "";
    userName =
        await DatabaseService().fetchDataOfUser(widget._user.uid, 'name') ?? "";
    privateKey = await DatabaseService()
            .fetchDataOfUser(widget._user.uid, 'privateAddress') ??
        "";
    publicWalletAddress = await DatabaseService()
        .fetchDataOfUser(_thisUser!.uid, 'publicAddress');

    if (this.mounted) {
      setState(() {});
    }
  }

  void checkMobileLink() async {
    isMobileLinked = await Authentication.isMobileLinked(_thisUser!.uid);

    if (isMobileLinked) {
      number = await DatabaseService.getMobileNumber(_thisUser!.uid);
    }
    setState(() {});
  }

  void checkPrivateAddressLink() async {
    isPrivateAddressLinked =
        await Authentication.isPrivateKeyAdded(_thisUser!.uid);
    if (isPrivateAddressLinked) {
      privateWalletAddress = await DatabaseService()
              .fetchDataOfUser(_thisUser!.uid, 'privateAddress') ??
          "";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              user: _thisUser!,
                              name: userName,
                              userType: userType)),
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
                              publicWalletAddress!.trim().length != 0
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
                              publicWalletAddress != null &&
                                      publicWalletAddress!.trim().length != 0
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
                                      child:
                                          Text("Enter Wallet Private Address !",
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
                    color: Colors.teal[100],
                  ),
                ),
                Spacer(),
              ],
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
    await DatabaseService.setMobileNumber(_thisUser!.uid, completeNumber);
    setState(() {
      number = completeNumber;
      isMobileLinked = true;
      mobileNumber = number;
      Navigator.of(context).pop();
    });
  }

  _linkPrivateAddress() async {
    var address = _privateAddressController.value.text.trim();

    if (address.length != 66) {
      print("Address not correct");
      return;
    }

    await DatabaseService.setPrivateAddress(_thisUser!.uid, address);
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
