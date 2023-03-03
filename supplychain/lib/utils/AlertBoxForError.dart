import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/functions.dart';


class AlertBoxForPrivateKeyError extends StatefulWidget {
  final User _user;
  final String _name;
  final String _type;
  const AlertBoxForPrivateKeyError(
      {super.key,
      required User user,
      required String name,
      required String type})
      : _user = user,
        _name = name,
        _type = type;

  @override
  State<AlertBoxForPrivateKeyError> createState() =>
      _AlertBoxForPrivateKeyErrorState();
}

class _AlertBoxForPrivateKeyErrorState
    extends State<AlertBoxForPrivateKeyError> {
  late User user;
  late String name;
  late String type;
  @override
  void initState() {
    user = widget._user;
    name = widget._name;
    type = widget._type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: AppTheme().themeGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: Text(
              "Enter Private Address",
              style: TextStyle(color: AppTheme.primaryColor),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Wallets's Private Address not Linked !\n\nPlease Link by going to.."),
                Text(
                  "Profile Page!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.primaryColor)),
                  onPressed: () {
                    Navigator.of(context)
                        .push(routeToProfile(user, name, type));
                  },
                  child: const Text(
                    "Go to Profile Page",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}


class AlertBoxForPrivateKeyErrorWithoutRoute extends StatefulWidget {
  const AlertBoxForPrivateKeyErrorWithoutRoute({super.key});

  @override
  State<AlertBoxForPrivateKeyErrorWithoutRoute> createState() => _AlertBoxForPrivateKeyErrorWithoutRouteState();
}

class _AlertBoxForPrivateKeyErrorWithoutRouteState extends State<AlertBoxForPrivateKeyErrorWithoutRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
                      height: MediaQuery.of(context).size.height * .7,
                      decoration:
                          BoxDecoration(gradient: AppTheme().themeGradient),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AlertDialog(
                            title: Text(
                              "Enter Private Address",
                              style: TextStyle(color: AppTheme.primaryColor),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Wallets's Private Address not Linked !\n\nPlease Link by going to.."),
                                Text(
                                  "Profile Page!",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
  }
}
