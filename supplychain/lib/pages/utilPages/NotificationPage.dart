import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/AppTheme.dart';
import 'package:supplychain/utils/constants.dart';

import '../../services/supplyController.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late SupplyController supplyController;
  late List<String> transactionList = [];

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    transactionList = supplyController.recentTransactions;
    return Scaffold(
        appBar: AppBar(
          title: Text("Recent Transactions"),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  for (String transaction in transactionList.reversed)
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                blurStyle: BlurStyle.normal)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(transaction.substring(0, 10) +
                              "***" +
                              transaction.substring(transaction.length - 4)),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          AppTheme.primaryColor)),
                              onPressed: () {
                                openLinkInBrowser(
                                    url: etherScanUrl + transaction);
                              },
                              child: Text("Check Status"))
                        ],
                      ),
                    )
                ],
              )),
            ),
          ],
        ));
  }
}
