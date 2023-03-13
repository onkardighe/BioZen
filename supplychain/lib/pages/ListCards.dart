import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/utils/supply.dart';

class ListCard {
  static Future<dynamic> userListCard(
      BuildContext context, List users, String? title) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return UserListCard(
            suppliers: users,
            title: title,
          );
        });
  }

  static Future<dynamic> bidderListCard(
      BuildContext context, Map bidders, String? title) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return BidderListCard(
            bidders: bidders,
            title: title,
          );
        });
  }

  static Future<dynamic> supplyListCard(
      BuildContext context, String? title) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SupplyListCard(
            // suppliers: users,
            title: title,
          );
        });
  }
}

class SupplyListCard extends StatefulWidget {
  final String? _title;
  const SupplyListCard({super.key, required String? title}) : _title = title;

  @override
  State<SupplyListCard> createState() => _SupplyListCardState();
}

class _SupplyListCardState extends State<SupplyListCard> {
  late String? title;
  bool isFirstTime = true;
  late SupplyController supplyController;
  late List<Supply> buySupplyList = [];
  late List<String> addedBidsList = [];

  @override
  void initState() {
    title = widget._title;
    super.initState();
  }

  void getSuppliesReadyToBuy() async {
    buySupplyList.clear();
    addedBidsList.clear();
    for (var supply in supplyController.notes) {
      if (!supply.isBuyerAdded) {
        buySupplyList.add(supply);
        await isAlreadyBidded(supply.id);
      }
    }
    setState(() {});
  }

  isAlreadyBidded(String id) async {
    var res = await DatabaseService.isBidderPresent(id, publicKey);
    if (!res) {
      addedBidsList.add(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    if (isFirstTime) {
      getSuppliesReadyToBuy();
      isFirstTime = false;
    }

    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.1,
          bottom: MediaQuery.of(context).size.height * 0.08),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Text(
                "Select biofuel to buy",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: AppTheme.primaryColor),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Divider(
              color: Colors.grey.shade700,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height * 0.66,
            child: ListView.builder(
                itemCount: buySupplyList.length,
                itemBuilder: (context, index) {
                  Supply supply = buySupplyList[index];

                  return Container(
                    height: MediaQuery.of(context).size.height * .25,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(
                            //container for green border
                            width: 5,
                            height: MediaQuery.of(context).size.height * .25,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(90),
                                    bottomLeft: Radius.circular(90)))),
                        Container(
                          padding: EdgeInsets.only(left: 15, top: 10),
                          width: MediaQuery.of(context).size.width * 0.82,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ID : " + supply.id,
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: AppTheme.primaryColor,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    supply.title,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Quantity : ",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Text("${supply.quantity} Kg",
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Created at : ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  Text(
                                      "${supply.createdAt.hour}:${supply.createdAt.minute}  ${supply.createdAt.day}/${supply.createdAt.month}/${supply.createdAt.year}",
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              ),
                              addedBidsList.contains(supply.id)
                                  ? Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          gradient: AppTheme().themeGradient,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextButton(
                                          onPressed: (() {
                                            AlertToAddBidAmount(
                                                context, supply);
                                            // DatabaseService.makeBid(
                                            //     supply.id, publicKey, 250);
                                          }),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.transparent)),
                                          child: Text(
                                            "Make a Bid",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  : Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Colors.green,
                                      size: 30,
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class UserListCard extends StatefulWidget {
  final List _users;
  final String? _title;
  const UserListCard(
      {super.key, required List suppliers, required String? title})
      : _users = suppliers,
        _title = title;

  @override
  State<UserListCard> createState() => _UserListCard();
}

class _UserListCard extends State<UserListCard> {
  late List users;
  late String? title;
  late List<Widget> userCards = [];
  bool selected = false;
  late String currentSelected;
  late var response = null;
  @override
  void initState() {
    users = widget._users;
    title = widget._title;
    _fetchList();
    super.initState();
  }

  _fetchList() {
    users.forEach((element) {
      userCards.add(GestureDetector(
        onTap: () {
          setState(() {
            response = element;
            selected = true;
            currentSelected = element['name'];
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: EdgeInsets.all(10),
            width: 250,
            height: 80,
            decoration: BoxDecoration(
                gradient: AppTheme().themeGradient,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  element['name'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  element['email'],
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      title != null
                          ? "SELECT ${title!.toUpperCase()}"
                          : "Select from list",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 35,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: users.isEmpty
                        ? [Text("No ${title}s Avaialble !")]
                        : userCards,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !selected && users.isNotEmpty
                        ? Text("Select ${title} From List !")
                        : SizedBox(),
                    selected
                        ? Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                gradient: AppTheme().themeGradient,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextButton(
                              onPressed: () {
                                if (selected) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(response);
                                }
                              },
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(100, 20)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Select $currentSelected ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.check_circle_rounded,
                                      size: 30, color: Colors.white),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 0,
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class BidderListCard extends StatefulWidget {
  final Map _bidders;
  final String? _title;
  const BidderListCard(
      {super.key, required Map bidders, required String? title})
      : _bidders = bidders,
        _title = title;

  @override
  State<BidderListCard> createState() => _BidderListCard();
}

class _BidderListCard extends State<BidderListCard> {
  late Map bidders;
  late String? title;
  late List<Widget> userCards = [];
  bool selected = false;
  late String currentSelected;
  late var response = null;
  @override
  void initState() {
    bidders = widget._bidders;
    title = widget._title;
    _fetchList();
    super.initState();
  }

  _fetchList() {
    bidders.forEach((userAddress, bidAmount) async {
      var bidderName = await DatabaseService().getNameByAddress(userAddress);
      setState(() {
        userCards.add(GestureDetector(
          onTap: () {
            setState(() {
              response = userAddress;
              selected = true;
              currentSelected = bidderName!;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              padding: EdgeInsets.all(10),
              width: 250,
              height: 80,
              decoration: BoxDecoration(
                  gradient: AppTheme().themeGradient,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${bidderName}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 1,
                    height: 15,
                    color: Colors.white30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Amount :",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${bidAmount} ₹",
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      title != null
                          ? "SELECT ${title!.toUpperCase()}"
                          : "Select from list",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, null);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 35,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bidders.isEmpty
                        ? [Text("No ${title}s Avaialble !")]
                        : userCards,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !selected && bidders.isNotEmpty
                        ? Text("Select ${title} From List !")
                        : SizedBox(),
                    selected
                        ? Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                gradient: AppTheme().themeGradient,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextButton(
                              onPressed: () {
                                if (selected) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(response);
                                }
                              },
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(100, 20)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Select $currentSelected ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(Icons.check_circle_rounded,
                                      size: 30, color: Colors.white),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 0,
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
