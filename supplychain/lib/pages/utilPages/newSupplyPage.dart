// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import 'package:supplychain/utils/Biofuels.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/utils/constants.dart';

class AddNewSupply extends StatefulWidget {
  final SupplyController _supplyController;

  const AddNewSupply({super.key, required SupplyController supplyController})
      : _supplyController = supplyController;

  @override
  State<AddNewSupply> createState() => _AddNewSupplyState();
}

class _AddNewSupplyState extends State<AddNewSupply> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _sourceLocationController = TextEditingController();
  late SupplyController supplyController;

  @override
  void initState() {
    supplyController = widget._supplyController;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor),
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
                                color: AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            email.substring(0, 3) +
                                "***" +
                                email.substring(
                                    email.indexOf('@'), email.length),
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // // // // // // // // // // // BODY // // // // // // // // // // //
                  InputNewSupply(
                    titleController: _titleController,
                    quantityController: _quantityController,
                    temperatureController: _temperatureController,
                    sourceLocationController: _sourceLocationController,
                    supplyController: supplyController,
                  ),
                  // // // // // // // // // // // ACTIONS // // // // // // // // // // //
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color>(
                  //             AppTheme.primaryColor)),
                  //     onPressed: () {
                  //       if (_titleController.value.text.isEmpty ||
                  //           _temperatureController.value.text.isEmpty ||
                  //           _quantityController.value.text.isEmpty) {
                  //         return;
                  //       }
                  //       _addNewSupply(
                  //           context,
                  //           supplyController,
                  //           _titleController.value.text.trim(),
                  //           double.tryParse(
                  //               _quantityController.value.text)!,
                  //           double.tryParse(
                  //               _temperatureController.value.text)!,
                  //           _sourceLocationController.value.text.trim());
                  //     },
                  //     child: const Text(
                  //       "Create Supply",
                  //       style: TextStyle(color: Colors.white),
                  //     )),
                  // // // // // // // // // // // // // // // // // // // // // // // // // // // // // //
                  // ElevatedButton(
                  //     onPressed: () {
                  //       showModalBottomSheet(
                  //           isScrollControlled: true,
                  //           backgroundColor: Colors.transparent,
                  //           context: context,
                  //           builder: (context) => Container(
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.vertical(
                  //                       top: Radius.circular(25.0),
                  //                     )),
                  //                 height:
                  //                     MediaQuery.of(context).size.height *
                  //                         0.5,
                  //                 padding: EdgeInsets.all(20),
                  //                 child: Text("This is new Container"),
                  //               ));
                  //     },
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color>(
                  //             AppTheme.primaryColor)),
                  //     child: Container(
                  //       child: Text("New"),
                  //     ))
                  // ],
                  // )
                ]),
          )),
    );
  }
}

class InputNewSupply extends StatefulWidget {
  final TextEditingController _titleController;
  final TextEditingController _quantityController;
  final TextEditingController _temperatureController;
  final TextEditingController _sourceLocationController;
  final SupplyController _supplyController;
  static SelectedBiofuel selectedBiofuel =
      SelectedBiofuel(Biofuel("", 0.0, 0.0));
  static double containerHeight = 350;
  static Widget contentWidget = new Container();
  const InputNewSupply(
      {super.key,
      required TextEditingController titleController,
      required TextEditingController quantityController,
      required TextEditingController temperatureController,
      required TextEditingController sourceLocationController,
      required SupplyController supplyController})
      : _titleController = titleController,
        _quantityController = quantityController,
        _temperatureController = temperatureController,
        _sourceLocationController = sourceLocationController,
        _supplyController = supplyController;

  @override
  State<InputNewSupply> createState() => _InputNewSupplyState();
}

class _InputNewSupplyState extends State<InputNewSupply> {
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _temperatureController;
  late TextEditingController _sourceLocationController;
  late SupplyController supplyController;
  late var pageNumber;

  // late Widget contentWidget;

  @override
  void initState() {
    InputNewSupply.contentWidget = supplyTypeSelector(callback: callback);
    _titleController = widget._titleController;
    _quantityController = widget._quantityController;
    _temperatureController = widget._temperatureController;
    _sourceLocationController = widget._sourceLocationController;
    supplyController = widget._supplyController;

    pageNumber = 1;

    super.initState();
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: InputNewSupply.contentWidget,
          transitionBuilder: (child, animation) {
            var begin = const Offset(1, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: InputNewSupply.selectedBiofuel.name == ""
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                if (pageNumber == 1) {
                  Navigator.of(context).pop();
                } else if (pageNumber == 2) {
                  setState(() {
                    pageNumber--;
                    InputNewSupply.contentWidget =
                        supplyTypeSelector(callback: callback);
                  });
                } else if (pageNumber == 3) {
                  setState(() {
                    pageNumber--;
                    InputNewSupply.contentWidget = CreateSupplyInputs(
                      titleController: _titleController,
                      quantityController: _quantityController,
                      temperatureController: _temperatureController,
                      sourceLocationController: _sourceLocationController,
                    );
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                  child: Icon(
                    Icons.arrow_circle_left,
                    size: 45,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        blurStyle: BlurStyle.normal)
                  ])),
            ),
            InputNewSupply.selectedBiofuel.name == ""
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      if (pageNumber == 1) {
                        setState(() {
                          pageNumber++;
                          InputNewSupply.contentWidget = CreateSupplyInputs(
                            titleController: _titleController,
                            quantityController: _quantityController,
                            temperatureController: _temperatureController,
                            sourceLocationController: _sourceLocationController,
                          );
                        });
                      } else if (pageNumber == 2) {
                        if (_temperatureController.value.text.trim().isEmpty ||
                            _quantityController.value.text.trim().isEmpty ||
                            _sourceLocationController.value.text
                                .trim()
                                .isEmpty) {
                          return;
                        }
                        setState(() {
                          pageNumber++;
                          //setting new values to selected supply
                          InputNewSupply.selectedBiofuel.quantity =
                              int.tryParse(
                                  _quantityController.value.text.trim())!;

                          InputNewSupply.selectedBiofuel.temperature =
                              double.tryParse(
                                  _temperatureController.value.text.trim())!;

                          InputNewSupply.selectedBiofuel.location =
                              _sourceLocationController.value.text.trim();

                          InputNewSupply.contentWidget = VerifySelectedSupply();
                        });
                      } else if (pageNumber == 3) {
                        _addNewSupply(
                            context,
                            supplyController,
                            InputNewSupply.selectedBiofuel.name,
                            InputNewSupply.selectedBiofuel.quantity.toDouble(),
                            InputNewSupply.selectedBiofuel.temperature,
                            InputNewSupply.selectedBiofuel.location);
                      }
                    },
                    child: Container(
                        child: Icon(
                          pageNumber == 3
                              ? Icons.check_circle_rounded
                              : Icons.arrow_circle_right,
                          size: 45,
                          color: InputNewSupply.selectedBiofuel.name == ""
                              ? Colors.white
                              : AppTheme.primaryColor,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  blurStyle: BlurStyle.normal)
                            ])),
                  ),
          ],
        ),
      ],
    );
  }
}

class supplyTypeSelector extends StatefulWidget {
  Function callback;
  supplyTypeSelector({super.key, required Function callback})
      : this.callback = callback;

  @override
  State<supplyTypeSelector> createState() => _supplyTypeSelectorState();
}

class _supplyTypeSelectorState extends State<supplyTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        child: Container(
            height: InputNewSupply.containerHeight,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  for (var biofuel in Biofuels.biofuelsList)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          InputNewSupply.selectedBiofuel =
                              SelectedBiofuel(biofuel);
                        });
                        widget.callback();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: InputNewSupply.selectedBiofuel.name ==
                                    biofuel.name
                                ? AppTheme().themeGradient
                                : null,
                            color: Colors.grey.shade50,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.normal)
                            ],
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Center(
                          child: Text(
                            biofuel.name,
                            style: TextStyle(
                                color: InputNewSupply.selectedBiofuel.name ==
                                        biofuel.name
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                ]))));
  }
}

class CreateSupplyInputs extends StatefulWidget {
  final TextEditingController _titleController;
  final TextEditingController _quantityController;
  final TextEditingController _temperatureController;
  final TextEditingController _sourceLocationController;
  const CreateSupplyInputs(
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
  State<CreateSupplyInputs> createState() => _CreateSupplyInputsState();
}

class _CreateSupplyInputsState extends State<CreateSupplyInputs> {
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _temperatureController;
  late TextEditingController _sourceLocationController;

  String? _tempErrorText = null;

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
    return Center(
      child: Container(
          // color: Colors.red,
          height: InputNewSupply.containerHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: AppTheme().themeGradient,
                      color: Colors.grey.shade50,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            blurStyle: BlurStyle.normal)
                      ],
                      border: Border.all(color: Colors.grey.shade200)),
                  child: Center(
                    child: Text(
                      InputNewSupply.selectedBiofuel.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _temperatureController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                    ],
                    keyboardType: TextInputType.numberWithOptions(),
                    style: TextStyle(color: AppTheme.primaryColor),
                    onChanged: (value) {
                      double? val = double.tryParse(value);
                      if (val != null &&
                          val >= InputNewSupply.selectedBiofuel.minTemp &&
                          val <= InputNewSupply.selectedBiofuel.maxTemp) {
                        _tempErrorText = null;
                      } else {
                        _tempErrorText =
                            "Provide temperature in range  :   ${InputNewSupply.selectedBiofuel.minTemp}°C to ${InputNewSupply.selectedBiofuel.maxTemp}°C";
                      }
                    },
                    decoration: InputDecoration(
                        suffix: Text(
                          "°C",
                          style: TextStyle(color: AppTheme.primaryColor),
                        ),
                        helperText:
                            "Temperature Range  :  ${InputNewSupply.selectedBiofuel.minTemp}°C to ${InputNewSupply.selectedBiofuel.maxTemp}°C",
                        label: Text("Temperature",
                            style: TextStyle(color: AppTheme.primaryColor)),
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        errorText: _tempErrorText,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _sourceLocationController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9, ]'))
                    ],
                    style: TextStyle(color: AppTheme.primaryColor),
                    decoration: InputDecoration(
                        label: Text("Supply location",
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
              ],
            ),
          )),
    );
  }
}

class VerifySelectedSupply extends StatefulWidget {
  const VerifySelectedSupply({super.key});

  @override
  State<VerifySelectedSupply> createState() => _VerifySelectedSupplyState();
}

class _VerifySelectedSupplyState extends State<VerifySelectedSupply> {
  TextStyle attributesTextStyle =
      TextStyle(color: AppTheme.primaryColor, fontSize: 17);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: InputNewSupply.containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.local_fire_department_sharp,
            size: 60,
            color: AppTheme.primaryColor,
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: AppTheme().themeGradient,
                color: Colors.grey.shade50,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      blurStyle: BlurStyle.normal)
                ],
                border: Border.all(color: Colors.grey.shade200)),
            child: Center(
              child: Text(
                InputNewSupply.selectedBiofuel.name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          attributeContainer(
              "Quantity", InputNewSupply.selectedBiofuel.quantity.toString()),
          attributeContainer("Temperature",
              InputNewSupply.selectedBiofuel.temperature.toString() + " °C"),
          attributeContainer(
              "Location", InputNewSupply.selectedBiofuel.location),
        ],
      ),
    );
  }

  Widget attributeContainer(var key, var val) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade50,
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                blurStyle: BlurStyle.normal)
          ],
          border: Border.all(color: Colors.grey.shade200)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(key, style: attributesTextStyle),
            Text(val, style: attributesTextStyle),
          ],
        ),
      ),
    );
  }
}

class SelectedBiofuel extends Biofuel {
  late int quantity;
  late double temperature;
  late String location;
  SelectedBiofuel(
    Biofuel selected,
  ) : super(selected.name, selected.minTemp, selected.maxTemp);
}

_addNewSupply(BuildContext context, SupplyController supplyController,
    String title, double quantity, double temp, String sourceLocation) async {
  var currDateTime = DateTime.now().toString();
  await supplyController
      .addSupply(title, quantity, temp, sourceLocation, currDateTime)
      .then((supplyAddress) async {
// Addd to DB to verify later
    if (supplyAddress != null && !supplyAddress.contains("Error")) {
      await supplyController.getTotalNumberOfSupplies().then((id) async {
        print("Got ID : $id");
        if (id >= 0) {
          await DatabaseService.addSupplyToDB(id.toString(), currDateTime);
        }
      });
      Navigator.of(context).pop();
    }
    checkResponse(supplyAddress, context, supplyController);
  });
}
