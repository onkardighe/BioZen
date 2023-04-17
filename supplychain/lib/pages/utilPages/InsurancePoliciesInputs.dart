import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import 'package:supplychain/utils/InsurancePolicies.dart';
import 'package:supplychain/utils/appTheme.dart';

import '../../utils/constants.dart';

class InsurancePoliciesInput extends StatefulWidget {
  const InsurancePoliciesInput({super.key});

  @override
  State<InsurancePoliciesInput> createState() => _InsurancePoliciesInputState();
}

class _InsurancePoliciesInputState extends State<InsurancePoliciesInput> {
  List<InsurancePolicy> userPolicies = [];
  var userName = "";
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await DatabaseService().fetchDataOfUser(user.uid, 'name').then((name) {
      setState(() {
        userName = name!;
      });
    });
    await DatabaseService.getPolicies(uid: user.uid).then((res) {
      if (res != null) {
        userPolicies = res;
      }

      setState(() {});
    });
  }

  callback() {
    setState(() {
      getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Column(children: [
          Container(
            //////////////////////////////// THEME CONTAINER ////////////////////////////////////////////////
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: AppTheme().themeGradient,
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                userName.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                insuranceAuthority,
                style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Divider(
                  height: 50,
                  color: AppTheme.secondaryColor,
                ),
              ),
              Text(
                "Insurance Policies",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              )
            ]),
          ),
          //////////////////////////////// POLICIES CONTAINER ////////////////////////////////////////////////
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: SingleChildScrollView(
              child: Column(children: [
                for (InsurancePolicy p in userPolicies)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 8,
                              spreadRadius: 1,
                              blurStyle: BlurStyle.normal)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.shield,
                            color: AppTheme.primaryColor,
                            size: 35,
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.55,

                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Price",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${p.price} ₹",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Coverage Amount",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${p.coverageAmount} ₹",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        ),
                        Spacer()
                      ],
                    ),
                  )
              ]),
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: AppTheme.primaryColor,
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 8,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.normal)
            ]),
        child: TextButton.icon(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90)),
                ),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(13))),
            onPressed: () {
              AlertBoxes.createPolicyAlertBox(
                  context: context, callback: callback);
            },
            icon: Icon(
              Icons.shield,
              color: Colors.white,
              size: 30,
            ),
            label: Text(
              "Create New Policy",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}

class CreateNewPolicy extends StatefulWidget {
  Function callback;
  CreateNewPolicy({super.key, required this.callback});

  @override
  State<CreateNewPolicy> createState() => _CreateNewPolicyState();
}

class _CreateNewPolicyState extends State<CreateNewPolicy> {
  TextEditingController _priceController = TextEditingController();
  TextEditingController _coverageAmountController = TextEditingController();
  List<dynamic> coverageList = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  // width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: AppTheme.primaryColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.shield,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "New Policy".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Insurance Authority",
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email.substring(0, 3) +
                          "***" +
                          email.substring(email.indexOf('@'), email.length),
                      overflow: TextOverflow.clip,
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: AppTheme.secondaryColor,
              ),
            ),
            NewPolicyInputs(
                priceController: _priceController,
                coverageList: coverageList,
                coverageAmountController: _coverageAmountController),
            //////////////////////////////////// Actions ////////////////////////////////////
            Spacer(),
            GestureDetector(
              onTap: () async {
                if (coverageList.isEmpty ||
                    _priceController.value.text.isEmpty ||
                    _coverageAmountController.value.text.isEmpty) {
                  return;
                }

                InsurancePolicy newPolicy = InsurancePolicy(
                    int.tryParse(_priceController.value.text)!,
                    int.tryParse(_coverageAmountController.value.text)!,
                    coverageList);

                if (newPolicy.price == null ||
                    newPolicy.coverageAmount == null) {
                  return;
                }

                await DatabaseService.createPolicy(
                  uid: user.uid,
                  newPolicy: newPolicy,
                ).then((res) {
                  if (res == null || false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error While Adding !")));
                    return;
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Added !")));
                  Navigator.of(context).pop();
                  widget.callback();
                });
              },
              child: Container(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    // color: AppTheme.primaryColor,
                    size: 45,
                  ),
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: AppTheme.shadowColor,
                        blurRadius: 9,
                        blurStyle: BlurStyle.normal)
                  ])),
            )
          ],
        ),
      ),
    );
  }
}

class NewPolicyInputs extends StatefulWidget {
  final TextEditingController _priceController;
  final TextEditingController _coverageAmountController;
  final List<dynamic> _coverageList;
  NewPolicyInputs({
    super.key,
    required TextEditingController priceController,
    required TextEditingController coverageAmountController,
    required List<dynamic> coverageList,
  })  : _priceController = priceController,
        _coverageList = coverageList,
        _coverageAmountController = coverageAmountController;

  @override
  State<NewPolicyInputs> createState() => _NewPolicyInputsState();
}

class _NewPolicyInputsState extends State<NewPolicyInputs> {
  late TextEditingController priceController;
  late TextEditingController coverageAmountController;
  late List<dynamic> coverageList;

  @override
  void initState() {
    priceController = widget._priceController;
    coverageList = widget._coverageList;
    coverageAmountController = widget._coverageAmountController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      // color: Colors.red,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        // ////////////////////////////// PRICE ////////////////////////////////// //
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: priceController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            keyboardType: TextInputType.numberWithOptions(),
            style: TextStyle(color: AppTheme.primaryColor),
            decoration: InputDecoration(
                suffixIcon: Container(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "₹",
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                label: Text("Price",
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
        // ////////////////////////////// COVERAGE AMOUNT ////////////////////////////////// //
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: coverageAmountController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            keyboardType: TextInputType.numberWithOptions(),
            style: TextStyle(color: AppTheme.primaryColor),
            decoration: InputDecoration(
                suffixIcon: Container(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "₹",
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                label: Text("Maximum Coverage Amount",
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
        // ////////////////////////////// COVERAGES ////////////////////////////////// //
        Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            width: MediaQuery.of(context).size.width,
            // height: openedCoverages ? null : 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      blurStyle: BlurStyle.normal)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Coverages",
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.keyboard_double_arrow_down,
                      size: 25,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                )),
                Divider(
                  color: Colors.grey.shade400,
                ),
                Container(
                  height: 180,
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      for (var cov in InsurancePolicies.allCoverageList)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (coverageList.contains(cov)) {
                                coverageList.remove(cov);
                              } else {
                                coverageList.add(cov);
                              }
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(),
                              coverageList.contains(cov)
                                  ? Icon(
                                      Icons.check_box_rounded,
                                      color: AppTheme.primaryColor,
                                      size: 27,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank_rounded,
                                      size: 27,
                                    ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20),
                                // margin: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  cov,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )
                    ]),
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text("${coverageList.length} selected")],
          ),
        )
      ]),
    );
  }
}
