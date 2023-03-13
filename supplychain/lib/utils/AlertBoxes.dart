import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/utils/supply.dart';

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

Future<void> showRawAlert(BuildContext context, String? titleText) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleText != null
              ? Text(
                  "$titleText",
                  style: TextStyle(color: AppTheme.primaryColor),
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
  String? titleText = "Make Bid";
  TextEditingController priceController = TextEditingController();
  String? priceError = null;
  showDialog(
      context: context,
      builder: (BuildContext context) {
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
            child: TextFormField(
              onEditingComplete: () {
                priceError = checkForValidPrice(priceController.value.text)
                    ? null
                    : "Invalid Price Amount";
                if (priceError == null) {
                  confirmPriceForBid(context, supply.id,
                      int.parse(priceController.value.text));
                }
              },
              onChanged: (value) {
                priceError =
                    checkForValidPrice(value) ? null : "Invalid Price Amount";
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
                  if (priceError == null) {
                    confirmPriceForBid(context, supply.id,
                        int.parse(priceController.value.text));
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

bool checkForValidPrice(String strPrice) {
  if (strPrice.isEmpty) {
    return false;
  }
  return true;
}

void confirmPriceForBid(BuildContext context, String id, int price) {
  print("confirming bid at $price");
  DatabaseService.makeBid(id, publicKey, price);
  Navigator.of(context).pop();
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Bid Successful for id : $id"),
  ));
}
