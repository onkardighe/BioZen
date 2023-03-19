import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: AlertDialog(
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
                  temperatureController: _temperatureController),
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
                supplyController.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
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
                              double.tryParse(
                                  _temperatureController.value.text)!);
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

  static _addNewSupply(
    BuildContext context,
    SupplyController supplyController,
    String title,
    double quantity,
    double temp,
  ) async {
    String? supplyAddress =
        await supplyController.addSupply(title, quantity, temp);
    Navigator.of(context).pop();
    checkResponse(supplyAddress, context, supplyController);
  }
}

class InputNewSupply extends StatefulWidget {
  final TextEditingController _titleController;
  final TextEditingController _quantityController;
  final TextEditingController _temperatureController;
  const InputNewSupply(
      {super.key,
      required TextEditingController titleController,
      required TextEditingController quantityController,
      required TextEditingController temperatureController})
      : _titleController = titleController,
        _quantityController = quantityController,
        _temperatureController = temperatureController;

  @override
  State<InputNewSupply> createState() => _InputNewSupplyState();
}

class _InputNewSupplyState extends State<InputNewSupply> {
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _temperatureController;

  @override
  void initState() {
    _titleController = widget._titleController;
    _quantityController = widget._quantityController;
    _temperatureController = widget._temperatureController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      // color: Colors.red,
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
          )
        ],
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

Future<void> showRawAlert(BuildContext context, String? titleText) async {
  print("into raw alert page");
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: titleText != null
              ? Text(
                  titleText,
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
  String? titleText = "Confirm Bid";
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
  showRawAlert(context, "Bid Successful for \nSupply ID : $id");
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   content: Text("Bid Successful for Supply id : $id"),
  // ));
}
