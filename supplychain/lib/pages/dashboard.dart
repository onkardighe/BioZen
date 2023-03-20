// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import '../utils/supply.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/services/DatabaseService.dart';
import '../services/functions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTag = 0;
  late SupplyController supplyController;
  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
                context, routeToHomePage(context), (route) => false)
            as Future<bool>;
      },
      child: Container(
        decoration: BoxDecoration(gradient: AppTheme().themeGradient),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_circle_left_rounded,
                      color: Colors.white, size: 36),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        routeToHomePage(context),
                        (Route<dynamic> route) => false);
                  }),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Container(
                      // width: 100,
                      width: 33,
                      height: 33,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppTheme.primaryColor),
                      child: supplyController.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : Center(
                              child: InkWell(
                                onTap: () {
                                  print("refreshed");
                                  supplyController.getNotes();
                                  supplyController.getSuppliesOfUser();
                                  supplyController.notifyListeners();
                                  setState(() {});
                                },
                                child: Icon(Icons.refresh_rounded, size: 22),
                              ),
                            )),
                )
              ],
              title: const Text(
                "DASHBOARD",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: privateKeyLinked
                    ? GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dx > 0) {
                            if (_selectedTag == 1) {
                              setState(() {
                                _selectedTag = 0;
                              });
                            }
                          } else {
                            if (_selectedTag == 0) {
                              setState(() {
                                _selectedTag = 1;
                              });
                            }
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CustomTabView(
                                  index: _selectedTag,
                                  changeTab: changeTab,
                                ),
                              ],
                            ),
                            _selectedTag == 0 ? OngoingList() : CompletedList(),
                          ],
                        ),
                      )
                    : AlertBoxForPrivateKeyErrorWithoutRoute(),
              ),
            ),
            bottomSheet: privateKeyLinked
                ? BottomSheet(
                    onClosing: () {},
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    builder: (context) {
                      return const SizedBox(
                        height: 60,
                        child: EnrollBottomSheet(),
                      );
                    },
                  )
                : SizedBox(),
          ),
        ),
      ),
    );
  }
}

class CompletedList extends StatefulWidget {
  const CompletedList({Key? key}) : super(key: key);

  @override
  State<CompletedList> createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  ScrollController _cardScrollController = new ScrollController();
  late SupplyController supplyController;
  late List<Supply> completedSupplyList = [];

  @override
  void initState() {
    super.initState();
  }

  fetchCompletedSupplies(List<Supply> userSupplyList) {
    for (var supply in userSupplyList) {
      if (supply.isCompleted) {
        completedSupplyList.add(supply);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    fetchCompletedSupplies(supplyController.userSupply);

    return Expanded(
      child: Container(
        color: Colors.grey.shade200,
        child: ListView.separated(
          controller: _cardScrollController,
          separatorBuilder: (_, __) {
            return const SizedBox(
              height: 20,
            );
          },
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          shrinkWrap: true,
          itemCount: completedSupplyList.length,
          itemBuilder: (_, index) {
            return packageCard(
              supply: completedSupplyList[index],
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width * 0.9,
              cardController: _cardScrollController,
            );
          },
        ),
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Function(int) changeTab;
  final int index;
  const CustomTabView({Key? key, required this.changeTab, required this.index})
      : super(key: key);

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  final List<String> _tags = ["Ongoing ", "Completed"];

  Widget _buildTagsBottom(int index) {
    return Expanded(
      child: Container(
        height: 5,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            color: widget.index == index
                ? index == 0
                    ? Colors.amber
                    : Colors.green
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .12, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _tags[index].toUpperCase(),
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _tags
                .asMap()
                .entries
                .map((MapEntry map) => _buildTags(map.key))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _tags
                .asMap()
                .entries
                .map((MapEntry map) => _buildTagsBottom(map.key))
                .toList(),
          )
        ],
      ),
    );
  }
}

class EnrollBottomSheet extends StatefulWidget {
  const EnrollBottomSheet({Key? key}) : super(key: key);

  @override
  State<EnrollBottomSheet> createState() => _EnrollBottomSheetState();
}

class _EnrollBottomSheetState extends State<EnrollBottomSheet> {
  late SupplyController supplyController;
  late List<Supply> myData;
  late List<Supply> supplyList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    supplyList = supplyController.userSupply;
    return Container(
      decoration: BoxDecoration(gradient: AppTheme().themeGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                AlertBoxes.showAlertForCreateSupply(context, supplyController);
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.post_add_sharp,
                    size: 25,
                    color: Colors.white,
                  ),
                  Text(
                    "Add Supply",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              )),
          TextButton(
              onPressed: () async {
                await displayAllOpenSupplies(context);
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.post_add_sharp,
                    size: 25,
                    color: Colors.white,
                  ),
                  Text(
                    "Buy Supply",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color? color;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.child,
    required this.height,
    required this.width,
    this.color = Colors.white,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Center(child: child),
        onTap: onTap,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 2.0,
            spreadRadius: .05,
          ), //BoxShadow
        ],
      ),
    );
  }
}

class OngoingList extends StatefulWidget {
  const OngoingList({Key? key}) : super(key: key);
  @override
  _OngoingListState createState() => _OngoingListState();
}

class _OngoingListState extends State<OngoingList> {
  ScrollController _cardScrollController = new ScrollController();
  late SupplyController supplyController;
  late List<Supply> supplyList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    supplyList = supplyController.userSupply;
    return Expanded(
      child: Container(
        color: Colors.grey.shade200,
        child: ListView.separated(
          controller: _cardScrollController,
          separatorBuilder: (_, __) {
            return const SizedBox(
              height: 20,
            );
          },
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          shrinkWrap: true,
          itemCount: supplyList.length,
          itemBuilder: (_, index) {
            return packageCard(
              supply: supplyList[index],
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width * 0.9,
              cardController: _cardScrollController,
            );
          },
        ),
      ),
    );
  }
}

class packageCard extends StatefulWidget {
  final Supply _supply;
  final double _height, _width;
  final ScrollController _cardController;
  const packageCard(
      {super.key,
      required Supply supply,
      required double height,
      required double width,
      required ScrollController cardController})
      : _supply = supply,
        _height = height,
        _width = width,
        _cardController = cardController;

  @override
  State<packageCard> createState() => _packageCardState();
}

class _packageCardState extends State<packageCard> {
  late Supply supply;
  late double height, width;
  late bool openedCard;
  late ScrollController cardController;
  late SupplyController supplyController;
  late String? supplierName;
  late String? buyerName = "Fuel Company";
  late String userType;

  @override
  void initState() {
    supply = widget._supply;
    height = widget._height;
    width = widget._width;
    openedCard = false;
    cardController = widget._cardController;
    fetchData();

    super.initState();
  }

  // void _scrollToCard() {

  // cardController.animateTo(
  //   (int.tryParse(supply.id)!) * ((widget._height) + 20) + 7,
  //   duration: const Duration(milliseconds: 500),
  //   curve: Curves.easeInOut,
  // );
  // }
  void fetchData() async {
    supplierName = await DatabaseService()
        .getNameByAddress(supply.supplierAddress.hexEip55);
    await DatabaseService()
        .fetchDataOfUser(user.uid, 'type')
        .then((userTypeResponse) => {userType = userTypeResponse!});
    if (mounted) {
      setState(() {});
    }
  }

  void toggleSize() {
    setState(() {
      height = openedCard ? height / 3 : height * 3;
      openedCard = !openedCard;
    });
    // _scrollToCard();
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    return GestureDetector(
      onTap: () {
        toggleSize();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: height,
              width: width,
              padding: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    blurStyle: BlurStyle.normal)
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      //container for yellow border
                      width: 5,
                      height: height - 3,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(90),
                              bottomLeft: Radius.circular(90)))),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width * 0.9,
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ID : ${supply.id}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            openedCard
                                ? Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.secondaryColor),
                                    child: TextButton(
                                      onPressed: () {
                                        toggleSize();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                        Text(
                          "${supply.title}",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        addSpacing(),
                        openedCard
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Package Details",
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Quantity : ",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            Text("${supply.quantity} Kg",
                                style: TextStyle(color: Colors.grey.shade700))
                          ],
                        ),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Temperature : ",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Text("${supply.temperature} °C",
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        addSpacing(),
                        openedCard
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Order Details",
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("From : ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  Text(supplierName ?? "Supplier",
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("To : ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  Text(buyerName!,
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Transporter : ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  Text("Onkar Dighe",
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Insurence : ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  Text("LIC ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Created at : ",
                                style: TextStyle(color: Colors.grey.shade700)),
                            openedCard
                                ? Text(
                                    "${supply.createdAt.hour} : ${supply.createdAt.minute}  ${supply.createdAt.day}/${supply.createdAt.month}/${supply.createdAt.year}",
                                    style:
                                        TextStyle(color: Colors.grey.shade700))
                                : Text(
                                    "${supply.createdAt.day}/${supply.createdAt.month}/${supply.createdAt.year}",
                                    style:
                                        TextStyle(color: Colors.grey.shade700))
                          ],
                        ),
                        addSpacing(),
                        SizedBox(
                          height: !openedCard ? 15 : 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.playlist_add_circle_rounded,
                              color: supply.isBuyerAdded
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            Container(
                              height: 5,
                              width: width / 6,
                              decoration: BoxDecoration(
                                color: supply.isTransporterAdded
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            Icon(
                              Icons.local_shipping_rounded,
                              color: supply.isTransporterAdded
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            Container(
                              height: 5,
                              width: width / 6,
                              decoration: BoxDecoration(
                                color: supply.isInsuranceAdded
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            Icon(
                              Icons.content_paste_search_rounded,
                              color: supply.isInsuranceAdded
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            Container(
                              height: 5,
                              width: width / 6,
                              decoration: BoxDecoration(
                                color: supply.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            Icon(
                              Icons.playlist_add_check_circle_rounded,
                              color: supply.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ],
                        ),
                        addSpacing(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    supply.isBuyerAdded
                                        ? SizedBox()
                                        : TextButton(
                                            onPressed: () async {
                                              var bidder =
                                                  await displayAllBidders(
                                                      context, supply.id);
                                              if (bidder != null) {
                                                addNewBuyer(supply.id, bidder);
                                              }
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(Colors.red)),
                                            child: Text(
                                              "Select Buyer",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                  ])
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  !supply.isBuyerAdded ||
                                          supply.isTransporterAdded
                                      ? SizedBox()
                                      : TextButton(
                                          onPressed: () async {
                                            var transporter =
                                                await displayAllTransporters(
                                                    context);
                                            if (transporter != null) {
                                              addNewTransporter(supply.id,
                                                  transporter['publicAddress']);
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(Colors.red)),
                                          child: Text(
                                            "Select Transporter",
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                  !supply.isBuyerAdded ||
                                          supply.isInsuranceAdded
                                      ? SizedBox()
                                      : TextButton(
                                          onPressed: () async {
                                            var insurer =
                                                await displayAllInsurers(
                                                    context);
                                            if (insurer != null) {
                                              addNewInsurance(supply.id,
                                                  insurer['publicAddress']);
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(Colors.red)),
                                          child: Text(
                                            "Select Insurance",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addNewBuyer(String id, String address) async {
    String? setBuyerresponse = await supplyController.setBuyer(id, address);

    if (mounted) {
      await checkResponse(setBuyerresponse, context, supplyController);
    }
  }

  void addNewTransporter(String id, String address) async {
    String? setTransporterresponse =
        await supplyController.setTransporter(id, address);

    if (mounted) {
      await checkResponse(setTransporterresponse, context, supplyController);
    }
  }

  void addNewInsurance(String id, String address) async {
    String? setBuyerresponse = await supplyController.setInsurance(id, address);
    if (mounted) {
      await checkResponse(setBuyerresponse, context, supplyController);
    }
  }

  Widget addSpacing() {
    if (!openedCard) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Container(
        height: 2,
        color: Colors.grey.shade100,
      );
    }
  }
}
