import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/utils/supply.dart';

class AlertBoxes {
  static Future<void> showAlertForCreateSupply(
      BuildContext context, SupplyController supplyController) async {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _quantityController = TextEditingController();
    TextEditingController _temperatureController = TextEditingController();
    TextEditingController _sourceLocationController = TextEditingController();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppTheme.primaryColor),
                    child: Icon(
                      Icons.post_add_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Owner",
                        style: TextStyle(
                            color: AppTheme.primaryColor, fontSize: 14),
                      ),
                      Text(
                        email.substring(0, 3) +
                            "***" +
                            email.substring(email.indexOf('@'), email.length),
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              content: InputNewSupply(
                titleController: _titleController,
                quantityController: _quantityController,
                temperatureController: _temperatureController,
                sourceLocationController: _sourceLocationController,
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
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.primaryColor)),
                    onPressed: () {
                      if (_titleController.value.text.isEmpty ||
                          _temperatureController.value.text.isEmpty ||
                          _quantityController.value.text.isEmpty) {
                        return;
                      }
                      AlertBoxes._addNewSupply(
                          context,
                          supplyController,
                          _titleController.value.text.trim(),
                          double.tryParse(_quantityController.value.text)!,
                          double.tryParse(_temperatureController.value.text)!,
                          _sourceLocationController.value.text.trim());
                    },
                    child: const Text(
                      "Create Supply",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          );
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

  static _addNewSupply(BuildContext context, SupplyController supplyController,
      String title, double quantity, double temp, String sourceLocation) async {
    String? supplyAddress =
        await supplyController.addSupply(title, quantity, temp, sourceLocation);
    Navigator.of(context).pop();
    checkResponse(supplyAddress, context, supplyController);
  }
}

class InputNewSupply extends StatefulWidget {
  final TextEditingController _titleController;
  final TextEditingController _quantityController;
  final TextEditingController _temperatureController;
  final TextEditingController _sourceLocationController;
  const InputNewSupply(
      {super.key,
      required TextEditingController titleController,
      required TextEditingController quantityController,
      required TextEditingController temperatureController,
      required TextEditingController sourceLocationController})
      : _titleController = titleController,
        _quantityController = quantityController,
        _temperatureController = temperatureController,
        _sourceLocationController = sourceLocationController;

  @override
  State<InputNewSupply> createState() => _InputNewSupplyState();
}

class _InputNewSupplyState extends State<InputNewSupply> {
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _temperatureController;
  late TextEditingController _sourceLocationController;

  @override
  void initState() {
    _titleController = widget._titleController;
    _quantityController = widget._quantityController;
    _temperatureController = widget._temperatureController;
    _sourceLocationController = widget._sourceLocationController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 310,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@. ]'))
                ],
                style: TextStyle(color: AppTheme.primaryColor),
                decoration: InputDecoration(
                    label: Text("Title",
                        style: TextStyle(color: AppTheme.primaryColor)),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.primaryColor, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _quantityController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: AppTheme.primaryColor),
                decoration: InputDecoration(
                    suffix: Text(
                      "Kg",
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                    label: Text("Quantity",
                        style: TextStyle(color: AppTheme.primaryColor)),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.primaryColor, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _temperatureController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: AppTheme.primaryColor),
                decoration: InputDecoration(
                    suffix: Text(
                      "°C",
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                    label: Text("Temperature",
                        style: TextStyle(color: AppTheme.primaryColor)),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.primaryColor, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _sourceLocationController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9, ]'))
                ],
                style: TextStyle(color: AppTheme.primaryColor),
                decoration: InputDecoration(
                    label: Text("Supply location",
                        style: TextStyle(color: AppTheme.primaryColor)),
                    labelStyle: TextStyle(color: Colors.grey.shade600),
                    floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.primaryColor, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor))),
              ),
            ),
          ],
        ),
      ),
    );
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
