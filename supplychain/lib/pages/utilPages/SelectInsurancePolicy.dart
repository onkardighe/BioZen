// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/utils/InsurancePolicies.dart';

import '../../utils/constants.dart';
import '../ListCards.dart';

class SelectInsurancePolicy extends StatefulWidget {
  final List<dynamic> policyList;
  final String supplyID;
  SelectInsurancePolicy(
      {super.key, required this.supplyID, required this.policyList});

  @override
  State<SelectInsurancePolicy> createState() => _SelectInsurancePolicyState();
}

class _SelectInsurancePolicyState extends State<SelectInsurancePolicy> {
  List<InsurancePolicy> policyList = [];

  TextStyle keyStyle = TextStyle(
    color: Colors.grey.shade700,
    fontSize: 15,
  );
  TextStyle valueStyle = TextStyle(
      color: Colors.grey.shade700, fontSize: 15, fontWeight: FontWeight.bold);

  @override
  void initState() {
    // policyList = widget.policyList;
    fetchData();
    super.initState();
  }

  fetchData() async {
    for (Map a in widget.policyList) {
      InsurancePolicy p =
          InsurancePolicy(a['price'], a['coverageAmount'], a['coverage']);
      policyList.add(p);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(children: [
        Container(
          height: 65,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              gradient: AppTheme().themeGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
          child: Center(
            child: Text(
              "Select Policy ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .66,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                policyList.length == 0
                    ? Text("NO policies found for this user !")
                    : SizedBox(),
                for (InsurancePolicy policy in policyList)
                  GestureDetector(
                    onTap: (() async {
                      // Add Policy

                      await DatabaseService.selectPolicyForSupply(
                              supplyId: widget.supplyID, newPolicy: policy)
                          .then((res) {
                        // selected = true;
                        Navigator.of(context).pop(true);
                      });
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                blurStyle: BlurStyle.normal)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price",
                                style: keyStyle,
                              ),
                              Text("${policy.price} ₹", style: valueStyle),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Maximum Coverage Amount",
                                style: keyStyle,
                              ),
                              Text("${policy.coverageAmount} ₹",
                                  style: valueStyle),
                            ],
                          ),
                          Divider(
                            height: 20,
                            color: AppTheme.secondaryColor,
                          ),
                          Text(
                            "${policy.coverages.length} Coverages",
                            textAlign: TextAlign.center,
                            style: valueStyle,
                          ),
                          Container(
                            height: 120,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var coverage in policy.coverages)
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.blur_circular,
                                                color: AppTheme.secondaryColor,
                                                size: 10,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                coverage,
                                                softWrap: true,
                                                style: keyStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
