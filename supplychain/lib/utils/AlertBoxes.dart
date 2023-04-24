import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:supplychain/pages/utilPages/InsurancePoliciesInputs.dart';
import 'package:supplychain/pages/utilPages/SelectInsurancePolicy.dart';
import 'package:supplychain/pages/utilPages/newSupplyPage.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/utils/supply.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../pages/utilPages/locationInfoPage.dart';

class AlertBoxes {
  static getRatings(BuildContext context) async {
    var res = null;
    await showDialog(
        context: context,
        builder: (context) {
          return RatingDialog(
              title: const Text("Rate your experience"),
              // message: Text("Tjis is message", style: TextStyle(fontSize: 15)),
              starSize: 35,
              enableComment: false,
              submitButtonText: "Submit",
              submitButtonTextStyle: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
              onSubmitted: (RatingDialogResponse ratings) {
                print("INter Ratings : ${ratings.rating}");
                res = ratings.rating;
                return ratings;
              });
        });

    return res != null ? res.toInt() : null;
  }

  static LocationInfoAlert(
      {required BuildContext context,
      required Supply supply,
      required var destLocation,
      required var history}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LocationInfoPage(
        supply: supply,
        destination: destLocation,
        history: history,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut.transform(animation.value);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }

  static createSupplyAlertBox(
      {required BuildContext context,
      required SupplyController supplyController}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => AddNewSupply(
        supplyController: supplyController,
      ),
    );
  }

  static createPolicyAlertBox(
      {required BuildContext context, required Function callback}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => CreateNewPolicy(callback: callback),
    );
  }

  static selectPolicyAlertBox(
      {required BuildContext context,
      required String supplyId,
      required List<dynamic> policies}) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SelectInsurancePolicy(
            supplyID: supplyId,
            policyList: policies,
          );
        });
  }

  static Future<void> showAlertForCreateSupply(
      BuildContext context, SupplyController supplyController) async {
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
          bool loading = false;
          return AddNewSupply(supplyController: supplyController);
        });
  }

  static showAlertForUpdateLocation(BuildContext context,
      SupplyController supplyController, Supply supply) async {
    TextEditingController _locationController = TextEditingController();
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
          bool loading = false;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppTheme.primaryColor),
                    child: Icon(
                      Icons.add_location_alt_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Update Location",
                    style:
                        TextStyle(fontSize: 20, color: AppTheme.primaryColor),
                  )
                ],
              ),
              content: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _locationController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9, ]'))
                    ],
                    style: TextStyle(color: AppTheme.primaryColor),
                    decoration: InputDecoration(
                        label: Text("Current location",
                            style: TextStyle(color: AppTheme.primaryColor)),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        floatingLabelStyle:
                            TextStyle(color: AppTheme.primaryColor),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor))),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                      AppTheme.primaryColor,
                    )),
                    onPressed: () {
                      Navigator.of(context).pop(null);
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
                    onPressed: () async {
                      var loc = _locationController.value.text;
                      if (loc.trim().isNotEmpty) {
                        var resp = await supplyController.updateLocation(
                            supply.id, loc);

                        print("resp : $resp");

                        if (resp != null && !resp.contains("Error")) {
                          // await showRawAlert(context,
                          //     "Updated Successfully !\n\nLatest : $loc");

                          Navigator.of(context, rootNavigator: true).pop(loc);
                        } else {
                          await showRawAlert(context, "Error ! Try Again !!");
                        }
                      }
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          );
        });
  }
}

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
                    Navigator.of(context).push(routeToProfile());
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
  State<AlertBoxForPrivateKeyErrorWithoutRoute> createState() =>
      _AlertBoxForPrivateKeyErrorWithoutRouteState();
}

class _AlertBoxForPrivateKeyErrorWithoutRouteState
    extends State<AlertBoxForPrivateKeyErrorWithoutRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
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
          ),
        ],
      ),
    );
  }
}

// Future<void> showRawAlert(BuildContext context, String? titleText,{required double size}) async {
Future<void> showRawAlert(
  BuildContext context,
  String? titleText,
) async {
  double size = 16.0;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleText != null
              ? Text(
                  titleText,
                  style:
                      TextStyle(color: AppTheme.primaryColor, fontSize: size),
                )
              : SizedBox(),
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
                  "Ok",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      });
}

Future<void> showTransactionAlert(
    BuildContext context, String? titleText, String transactionAddress) async {
  double size = 16.0;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleText != null
              ? Text(
                  titleText,
                  style:
                      TextStyle(color: AppTheme.primaryColor, fontSize: size),
                )
              : SizedBox(),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                )),
                onPressed: () {
                  openLinkInBrowser(url: etherScanUrl + transactionAddress);
                },
                child: const Text(
                  "Check Status",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                style: ButtonStyle(   
                    backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      });
}

Future<void> AlertToAddBidAmount(BuildContext context, Supply supply) async {
  String? titleText = "Confirm Bid";
  TextEditingController priceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  String? priceError = null;
  showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut.transform(animation.value);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
      context: context,
      pageBuilder: (BuildContext context, animation, secondaryAnimation) {
        return AlertDialog(
          title: titleText != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$titleText",
                      style:
                          TextStyle(color: AppTheme.primaryColor, fontSize: 18),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Supply Details",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ID :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.id}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Title :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.title}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quantity :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.quantity} Kg",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Temperature :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.temperature} °C",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          content: Container(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  onEditingComplete: () {
                    priceError = checkForValidPrice(priceController.value.text)
                        ? null
                        : "Invalid Price Amount";
                  },
                  onChanged: (value) {
                    priceError = checkForValidPrice(value)
                        ? null
                        : "Invalid Price Amount";
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  controller: priceController,
                  style: TextStyle(color: AppTheme.primaryColor),
                  decoration: InputDecoration(
                      suffixText: "₹",
                      suffixStyle: TextStyle(color: AppTheme.primaryColor),
                      errorText: priceError,
                      floatingLabelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                      label: Text(
                        "Bid Price",
                        style: TextStyle(color: AppTheme.primaryColor),
                      )),
                ),
                TextField(
                  controller: destinationController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9, ]'))
                  ],
                  style: TextStyle(color: AppTheme.primaryColor),
                  decoration: InputDecoration(
                      label: Text("Destination",
                          style: TextStyle(color: AppTheme.primaryColor)),
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      floatingLabelStyle:
                          TextStyle(color: AppTheme.primaryColor),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.primaryColor, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppTheme.primaryColor))),
                ),
              ],
            ),
          ),
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
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                )),
                onPressed: () {
                  priceError = checkForValidPrice(priceController.value.text)
                      ? null
                      : "Invalid Price Amount";
                  if (destinationController.value.text.trim().isEmpty) {
                    return;
                  }
                  if (priceError == null) {
                    confirmPriceForBid(
                        context,
                        supply.id,
                        int.parse(priceController.value.text),
                        destinationController.value.text.trim());
                  }
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      });
}

AlertToSelectSupply(BuildContext context, Supply supply,
    {required String titleText}) async {
  // String? titleText = "Secure Supply";
  return showGeneralDialog(
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut.transform(animation.value);
        return ScaleTransition(
          scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
      context: context,
      pageBuilder: (BuildContext context, animation, secondaryAnimation) {
        return AlertDialog(
          title: titleText != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$titleText",
                      style:
                          TextStyle(color: AppTheme.primaryColor, fontSize: 18),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Supply Details",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ID :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.id}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Title :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.title}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quantity :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.quantity} Kg",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Temperature :",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(
                          "${supply.temperature} °C",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          // content:
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                )),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                )),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      });
}

bool checkForValidPrice(String strPrice) {
  if (strPrice.isEmpty) {
    return false;
  }
  return true;
}

void confirmPriceForBid(
    BuildContext context, String id, int price, String destination) {
  print("confirming bid at $price to Destination $destination");
  DatabaseService.makeBid(id, publicKey, price, destination);
  Navigator.of(context).pop();
  Navigator.of(context).pop();
  showRawAlert(context, "Bid Successful for \nSupply ID : $id");
}
