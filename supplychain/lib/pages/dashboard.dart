// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:supplychain/pages/ListCards.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import '../utils/supply.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/utils/AppTheme.dart';
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
                          if (details.delta.dx > 5) {
                            if (_selectedTag == 1) {
                              setState(() {
                                _selectedTag = 0;
                              });
                            }
                          } else if (details.delta.dx < 5) {
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
    completedSupplyList.clear();
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
        child: completedSupplyList.isEmpty
            ? Center(child: Text("No Completed Supplies found !!"))
            : ListView.separated(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          userType != supplier
              ? SizedBox()
              : TextButton(
                  onPressed: () {
                    // AlertBoxes.showAlertForCreateSupply(
                    //     context, supplyController);
                    AlertBoxes.createSupplyAlertBox(
                        context: context, supplyController: supplyController);
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
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
          userType != fuelCompany
              ? SizedBox()
              : TextButton(
                  onPressed: () async {
                    await displayAllOpenSupplies(context);
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
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
          userType == insuranceAuthority || userType == transportAuthority
              ? TextButton(
                  onPressed: () async {
                    // for Insurence Authority
                    if (userType == insuranceAuthority) {
                      var suppliesForCurrentInsuer =
                          await DatabaseService.getSupplyIDsOfSelectedUser(
                              publicKey,
                              type: insuranceAuthority);
                      // print(suppliesForCurrentInsuer);

                      await displayListSpecificSupplies(
                          context, suppliesForCurrentInsuer, "Secure supply");
                    } else {
                      // for Transport Authority
                      var suppliesForCurrentTransporter =
                          await DatabaseService.getSupplyIDsOfSelectedUser(
                              publicKey,
                              type: transportAuthority);
                      await displayListSpecificSupplies(context,
                          suppliesForCurrentTransporter, "Select Package");
                      // print(suppliesForCurrentTransporter);
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.post_add_sharp,
                        size: 25,
                        color: Colors.white,
                      ),
                      Text(
                        "Explore Supply",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ))
              : SizedBox(),
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
  List<Supply> supplyList = [];

  @override
  void initState() {
    super.initState();
  }

  fetchOngoingSupplies(List<Supply> userSupplyList) {
    supplyList.clear();
    for (var supply in userSupplyList) {
      if (!supply.isCompleted) {
        supplyList.add(supply);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    supplyController = Provider.of<SupplyController>(context, listen: true);
    fetchOngoingSupplies(supplyController.userSupply);
    // supplyList = ;
    return Expanded(
      child: Container(
        color: Colors.grey.shade200,
        child: supplyList.isEmpty
            ? Center(child: Text("No Ongoing Supplies found !!"))
            : ListView.separated(
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
  late Supply _supply;
  late double _height, _width;
  late ScrollController _cardController;

  packageCard(
      {super.key,
      required Supply supply,
      required double height,
      required double width,
      required ScrollController cardController}) {
    _supply = supply;
    _height = height;
    _width = width;
    _cardController = cardController;
  }

  @override
  State<packageCard> createState() => _packageCardState();
}

class _packageCardState extends State<packageCard> {
  late Supply supply;
  late double height, width;
  late bool openedCard;
  late ScrollController cardController;
  late SupplyController supplyController;
  bool insuranceSelected = false;
  late String? supplierName = "Not selected",
      buyerName = "Not selected",
      transporterName = "Not selected",
      insuranceName = "Not selected";
  String transporterAddress = "", insurerAddress = "", fuelCompanyAddress = "";
  late List locationHistoryList = [];
  late String? sourceLocation = "Not selected",
      destination = "Not selected",
      currentLocation = sourceLocation;
  late String userType = '';
  var supplyDeliveryChecks = Map<String, dynamic>();
  bool showCompleteButton = false, showlocationinfo = false;

  @override
  void initState() {
    supply = widget._supply;
    height = widget._height;
    width = widget._width;
    openedCard = false;
    cardController = widget._cardController;
    fetchSupplyData();
    fetchSupplyDeliveryData();

    super.initState();
  }

  void fetchSupplyDeliveryData() async {
    // supplyDeliveryChecks =

    await DatabaseService()
        .fetchDataOfUser(user.uid, 'type')
        .then((UserType) async {
      userType = UserType!;
      await DatabaseService.getSupplydeliveryStatus(supply.id).then((check) {
        if (check == null) {
          return;
        }
        if (check['markedAsCompleted']) {
          // if already completed
          showCompleteButton = false;
        } else if (userType == transportAuthority) {
          // not completed
          showCompleteButton = !check['transportDelivered'];
        } else if (userType == fuelCompany) {
          showCompleteButton =
              check['transportDelivered'] && !check['buyerReceived'];
        } else if (userType == insuranceAuthority) {
          showCompleteButton = check['buyerReceived'] &&
              check['transportDelivered'] &&
              !check['insurerVerified'];
        } else if (userType == supplier) {
          // for supplier
          showCompleteButton = check['buyerReceived'] &&
              check['transportDelivered'] &&
              check['insurerVerified'];
        }
      });
    });

    if (mounted) {
      setState(() {});
    }
  }

  void fetchSupplyData() async {
    supplierName = await DatabaseService()
        .getNameByAddress(supply.supplierAddress.hexEip55);

    //getting location history
    await supplyController
        .getLocationHistory(BigInt.parse(supply.id))
        .then((response) {
      if (response != null) {
        locationHistoryList = response;
        sourceLocation = locationHistoryList.first;
        currentLocation = locationHistoryList.last;
        showlocationinfo = true;
      }
    });

    // getting destination
    await supplyController
        .getDestination(BigInt.parse(supply.id))
        .then((response) {
      if (response != null) {
        destination = response;
        showlocationinfo = true;
        // print(response);
      }
    });

    //getBuyer
    if (supply.isBuyerAdded) {
      await supplyController
          .getSubscribers(BigInt.parse(supply.id), fuelCompany)
          .then((responseAddress) async {
        fuelCompanyAddress = responseAddress.hexEip55;
        buyerName =
            await DatabaseService().getNameByAddress(responseAddress.hexEip55);
        if (mounted) {
          setState(() {});
        }
      });
    }

    //getTransporter
    if (supply.isTransporterAdded) {
      await supplyController
          .getSubscribers(BigInt.parse(supply.id), transportAuthority)
          .then((responseAddress) async {
        if (responseAddress == null) {
          return;
        }
        transporterAddress = responseAddress.hexEip55;

        transporterName =
            await DatabaseService().getNameByAddress(responseAddress.hexEip55);
        if (mounted) {
          setState(() {});
        }
      });
    }

    //getInsurance
    if (supply.isInsuranceAdded) {
      await supplyController
          .getSubscribers(BigInt.parse(supply.id), insuranceAuthority)
          .then((responseAddress) async {
        if (responseAddress == null) {
          return;
        }
        insurerAddress = responseAddress.hexEip55;

        insuranceName =
            await DatabaseService().getNameByAddress(responseAddress.hexEip55);
        if (mounted) {
          setState(() {});
        }
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  void toggleSize() {
    setState(() {
      height = openedCard ? height / 3 : height * 3;
      openedCard = !openedCard;
    });
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
              decoration: BoxDecoration(boxShadow: const [
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
                          color:
                              supply.isCompleted ? Colors.green : Colors.amber,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(90),
                              bottomLeft: Radius.circular(90)))),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width * 0.9,
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
                                      // color: AppTheme.secondaryColor
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        toggleSize();
                                      },
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.red.shade300,
                                        size: 27,
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
                        openedCard ? addSpacing() : SizedBox(),
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
                        openedCard ? addSpacing() : SizedBox(),
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
                                  Text("Supplier : ",
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
                                  Text("Buyer : ",
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  Text(
                                      supply.isBuyerAdded && buyerName != null
                                          ? buyerName!
                                          : "Not selected",
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
                                  Text(
                                      supply.isTransporterAdded &&
                                              transporterName != null
                                          ? transporterName!
                                          : "Not selected",
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
                                  Text(
                                      supply.isInsuranceAdded &&
                                              insuranceName != null
                                          ? insuranceName!
                                          : "Not selected",
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
                        openedCard ? addSpacing() : SizedBox(),
                        openedCard
                            ? Stack(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Location Details",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                showlocationinfo
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context).push(
                                                  AlertBoxes.LocationInfoAlert(
                                                      context: context,
                                                      supply: supply,
                                                      destLocation: destination,
                                                      history:
                                                          locationHistoryList));
                                              ;
                                            },
                                            child: Icon(Icons.info,
                                                color: Colors.grey.shade700),
                                          ),
                                        ],
                                      )
                                    : SizedBox()
                              ])
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "From : ",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Text(sourceLocation!,
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        supply.isBuyerAdded && openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "To : ",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Text(destination!,
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        !supply.isCompleted
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Current Location : ",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Text(currentLocation!,
                                      style: TextStyle(
                                          color: Colors.grey.shade700))
                                ],
                              )
                            : SizedBox(),
                        openedCard ? SizedBox(height: 10) : SizedBox(),
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
                        openedCard ? addSpacing() : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    supply.isBuyerAdded
                                        ? SizedBox()
                                        : userType != supplier
                                            ? SizedBox()
                                            : TextButton(
                                                onPressed: () async {
                                                  var bidderDetails =
                                                      await displayAllBidders(
                                                          context, supply.id);
                                                  if (bidderDetails != null) {
                                                    addNewBuyer(
                                                        supply.id,
                                                        bidderDetails[
                                                            'address'],
                                                        bidderDetails[
                                                            'destination']);
                                                  }
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll<
                                                                Color>(
                                                            Colors.amber)),
                                                child: Text(
                                                  "Select Buyer",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                  ])
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  !supply.isBuyerAdded ||
                                          supply.isTransporterAdded ||
                                          userType != fuelCompany
                                      ? SizedBox()
                                      : TextButton(
                                          onPressed: () async {
                                            var transporter =
                                                await displayAllTransporters(
                                                    context, supply.id);
                                            print("Transporter : $transporter");
                                            if (transporter != null) {
                                              DatabaseService.selectTransporter(
                                                  supply.id,
                                                  transporter['publicAddress']);
                                              showRawAlert(context,
                                                  "${transporter['name']}\nSelected as Transporter\nWaiting for their Response !");
                                            }
                                            // if (transporter != null) {
                                            //   addNewTransporter(supply.id,
                                            //       transporter['publicAddress']);
                                            // }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(Colors.amber)),
                                          child: Text(
                                            "Select Transporter",
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                  !supply.isBuyerAdded ||
                                          !supply.isTransporterAdded ||
                                          supply.isInsuranceAdded ||
                                          userType != fuelCompany
                                      ? SizedBox()
                                      : TextButton(
                                          onPressed: () async {
                                            var insurer =
                                                await displayAllInsurers(
                                                    context, supply.id);

                                            if (insurer != null) {
                                              await DatabaseService
                                                  .selectInsurer(supply.id,
                                                      insurer['publicAddress']);
                                              await showRawAlert(context,
                                                  "Selected ${insurer['name']}\nas Insurer ! ");
                                              if (mounted) {
                                                setState(() {
                                                  insuranceSelected = true;
                                                });
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                          Color>(
                                                      insuranceSelected
                                                          ? Colors.grey
                                                          : Colors.amber)),
                                          child: Text(
                                            "Select Insurance",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                  userType != transportAuthority ||
                                          !supply.isTransporterAdded
                                      ? SizedBox()
                                      : !showCompleteButton
                                          ? SizedBox()
                                          : TextButton(
                                              onPressed: () async {
                                                if (!supply.isInsuranceAdded) {
                                                  var buyer = await showRawAlert(
                                                      context,
                                                      "Waiting for ${buyerName!.contains("Not selected") ? "buyer" : buyerName}\nto add insurance ");
                                                } else {
                                                  var updated = await AlertBoxes
                                                      .showAlertForUpdateLocation(
                                                          context,
                                                          supplyController,
                                                          supply);
                                                  if (updated != null) {
                                                    print("Updaed : $updated");
                                                    return await showRawAlert(
                                                        context,
                                                        "Updated Successfully !\n");
                                                  } else {
                                                    print("Got : $updated");
                                                  }
                                                }
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll<
                                                          Color>(supply
                                                              .isInsuranceAdded
                                                          ? Colors.amber
                                                          : Colors.grey)),
                                              child: Text(
                                                "Update Current Location",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                ],
                              )
                            : SizedBox(),
                        !openedCard || !supply.isInsuranceAdded
                            ? SizedBox()
                            : !showCompleteButton
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            late var addressToRate;
                                            switch (userType) {
                                              case "Fuel Company":
                                                addressToRate =
                                                    transporterAddress;
                                                break;
                                              case "Insurance Authority":
                                                addressToRate = supply
                                                    .supplierAddress.hexEip55;
                                                break;
                                              case "Transport Authority":
                                                addressToRate =
                                                    fuelCompanyAddress;
                                                break;
                                              case "Supplier":
                                                addressToRate = insurerAddress;
                                                break;
                                              default:
                                                addressToRate = supply
                                                    .supplierAddress.hexEip55;
                                            }

                                            if (userType == supplier) {
                                              // if supplier - > chenges on BCT
                                              await supplyController
                                                  .completeSupply(supply.id,
                                                      DateTime.now().toString())
                                                  .then((res) async {
                                                if (res == null ||
                                                    res.contains('Error')) {
                                                  // Error Found
                                                  await showRawAlert(context,
                                                      'Error !! Try again !');
                                                } else {
                                                  // AlertBox for Getting Ratings
                                                  await AlertBoxes.getRatings(
                                                          context)
                                                      .then((ratings) async {
                                                    await DatabaseService
                                                            .verifySupplyToComplete(
                                                                supply.id,
                                                                userType)
                                                        .then((res) async {
                                                      if (ratings == null) {
                                                        return;
                                                      }

                                                      // address of transporter
                                                      if (addressToRate != "") {
                                                        print(
                                                            "Ratings got : $ratings");
                                                        await DatabaseService
                                                            .updateRating(
                                                                address:
                                                                    addressToRate,
                                                                ratings:
                                                                    ratings);
                                                      }
                                                    });
                                                  });

                                                  if (mounted) {
                                                    await showRawAlert(context,
                                                        'Supply Completed !');
                                                    setState(() {
                                                      showCompleteButton =
                                                          false;
                                                    });
                                                  }
                                                }
                                              });
                                            } else {
                                              // AlertBox for Getting Ratings
                                              await AlertBoxes.getRatings(
                                                      context)
                                                  .then((ratings) async {
                                                await DatabaseService
                                                        .verifySupplyToComplete(
                                                            supply.id, userType)
                                                    .then((res) async {
                                                  if (ratings == null) {
                                                    return;
                                                  }

                                                  // address of transporter
                                                  if (addressToRate != "") {
                                                    print(
                                                        "Ratings got : $ratings");
                                                    await DatabaseService
                                                        .updateRating(
                                                            address:
                                                                addressToRate,
                                                            ratings: ratings);
                                                  }
                                                });
                                              });

                                              if (mounted) {
                                                await showRawAlert(context,
                                                    'Supply Completed !');
                                                setState(() {
                                                  showCompleteButton = false;
                                                });
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll<
                                                      Color>(Colors.amber)),
                                          child: Text(
                                            userType == transportAuthority
                                                ? "Mark as Delivered"
                                                : userType == insuranceAuthority
                                                    ? "Verify Supply"
                                                    : userType == fuelCompany
                                                        ? "Supply Received"
                                                        : userType == supplier
                                                            ? "Mark Supply Completed"
                                                            : "",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ],
                                  ),
                        !openedCard
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(routeToSupportPage());
                                },
                                child: Container(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.question_answer_sharp,
                                          color: Colors.grey.shade700),
                                      Text("Facing issues ? Contact Support"),
                                      Icon(
                                          Icons
                                              .keyboard_double_arrow_right_rounded,
                                          color: Colors.grey.shade700),
                                    ],
                                  ),
                                ),
                              )
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

  void addNewBuyer(String id, String address, String destination) async {
    print("Bidder Address : $address \n Bidder destination : $destination");

    String? setBuyerresponse =
        await supplyController.setBuyer(id, address, destination);

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
}
