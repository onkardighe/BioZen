import 'package:flutter/material.dart';
import 'package:supplychain/utils/Authentication.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/utils/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

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
  var isMobileLinked = true;
  var number = '';
  var copyIcon = Icon(Icons.copy_rounded);

  @override
  void initState() {
    userName = widget.userName;
    _thisUser = widget._user;
    userType = widget.userType;
    super.initState();
    checkMobileLink();
  }

  void checkMobileLink() async {
    isMobileLinked = await Authentication.isMobileLinked(_thisUser!.uid);
    if (isMobileLinked) {
      number = await DatabaseService.getMobileNumber(_thisUser!.uid);
    }
    setState(() {});
    print(await Authentication.isMobileLinked(_thisUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  Navigator.pop(context);
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
                        Icons.phone_android_rounded,
                        color: Colors.deepPurple,
                      ),
                      title: isMobileLinked
                          ? Text(
                              number,
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            )
                          : TextFormField(
                              onEditingComplete: () => _linkMobileNumber(),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              controller: _mobileLinkController,
                              style: TextStyle(color: Colors.deepPurple),
                              decoration: InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                label: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Link Mobile Number ! ",
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 17,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: Colors.deepPurple,
                      ),
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
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.medical_information_outlined,
                        color: Colors.deepPurple,
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                            text: _thisUser!.uid ?? "",
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
                        _thisUser!.uid ?? "User Not Found !!",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 14,
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

  _linkMobileNumber() async {
    if (_mobileLinkController.value.text.length != 10) {
      print("Lengh not correct");
      return;
    }

    var completeNumber = "+91" + _mobileLinkController.value.text;
    await DatabaseService.setMobileNumber(_thisUser!.uid, completeNumber);
    setState(() {
      number = completeNumber;
      isMobileLinked = true;
    });
  }
}
