// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:supplychain/utils/AlertBoxForError.dart';
import '../utils/supply.dart';
import 'package:provider/provider.dart';
import 'package:supplychain/utils/appTheme.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/services/DatabaseService.dart';
import 'package:web3dart/web3dart.dart';
import '../services/functions.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _selectedTag = 0;
  late NoteController noteController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    noteController = Provider.of<NoteController>(context, listen: true);
    return Container(
      decoration: BoxDecoration(gradient: AppTheme().themeGradient),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_circle_left_rounded,
                  color: Colors.white, size: 36),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
                        shape: BoxShape.circle, color: Colors.indigo.shade400),
                    child: noteController.isLoading
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
                                noteController.getNotes();
                                noteController.getSuppliesOfUser();
                                noteController.notifyListeners();
                                setState(() {});
                              },
                              child: Icon(Icons.refresh_rounded, size: 22),
                            ),
                          )),
              )
            ],
            title: const Text(
              "ORDERS",
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
                  ? Column(
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
                        _selectedTag == 0
                            ? const OngoingList()
                            : const Description(),
                      ],
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
    );
  }
}

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          "Not complete yet",
          style: TextStyle(color: Colors.white),
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
  _EnrollBottomSheetState createState() => _EnrollBottomSheetState();
}

class _EnrollBottomSheetState extends State<EnrollBottomSheet> {
  late NoteController noteController;
  late List<Supply> myData;
  // String email = "onkardigheofficial@gmail.com";
  late List<Supply> supplyList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    noteController = Provider.of<NoteController>(context, listen: true);
    supplyList = noteController.userSupply;
    return Container(
      decoration: BoxDecoration(gradient: AppTheme().themeGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                showAlert();
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
              onPressed: () {
                TestFunction();
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
                    "Check",
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

  void TestFunction() async {
    print("Clicked");
    await noteController.getSuppliesOfUser();
    noteController.notifyListeners();
  }

  Future<void> showAlert() async {
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
                            color: Colors.grey.shade600, fontSize: 14),
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
                      Colors.grey.shade700,
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
                noteController.isLoading
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
                            print("Invalid !");
                            return;
                          }
                          addNewSupply(
                              _titleController.value.text.trim(),
                              double.tryParse(_quantityController.value.text)!,
                              double.tryParse(
                                  _temperatureController.value.text)!);
                        },
                        child: const Text(
                          "Add Supply",
                          style: TextStyle(color: Colors.white),
                        )),
              ],
            ),
          );
        });
  }

  void addNewSupply(String title, double quantity, double temp) async {
    String? supplyAddress =
        await noteController.addSupply(title, quantity, temp);
    checkResponse(supplyAddress, context);
    Navigator.of(context).pop();
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
                  label: Text(
                    "Title",
                  ),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primaryColor, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
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
                  label: Text(
                    "Quantity",
                  ),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primaryColor, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
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
                  label: Text(
                    "Temperature",
                  ),
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.primaryColor, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor))),
            ),
          )
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
  late NoteController noteController;
  late List<Supply> supplyList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    noteController = Provider.of<NoteController>(context, listen: true);
    supplyList = noteController.userSupply;
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
  late NoteController noteController;
  late String? supplierName;

  @override
  void initState() {
    supply = widget._supply;
    height = widget._height;
    width = widget._width;
    openedCard = false;
    cardController = widget._cardController;
    fetchSupplyData();

    super.initState();
  }

  void _scrollToCard() {
    cardController.animateTo(
      (int.tryParse(supply.id)!) * ((widget._height) + 20) + 7,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void fetchSupplyData() async {
    supplierName = await DatabaseService()
        .getNameByAddress(supply.supplierAddress.hexEip55);
  }

  void toggleSize() {
    setState(() {
      height = openedCard ? height / 3 : height * 3;
      openedCard = !openedCard;
    });
    _scrollToCard();
  }

  @override
  Widget build(BuildContext context) {
    noteController = Provider.of<NoteController>(context, listen: true);
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
                                        color: Colors.deepPurple.shade50),
                                    child: TextButton(
                                      onPressed: () {
                                        toggleSize();
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.deepPurple,
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
                                  Text("Fuel Company",
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
                                    TextButton(
                                        onPressed: () async {
                                          addNewBuyer(supply.id, publicKey);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.red)),
                                        child: Text(
                                          "Select Buyer",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ])
                            : SizedBox(),
                        openedCard
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        addNewTransporter(supply.id, publicKey);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                                  Colors.red)),
                                      child: Text(
                                        "Select Transporter",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        addNewInsurance(supply.id, publicKey);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                                  Colors.red)),
                                      child: Text(
                                        "Select Insurance",
                                        style: TextStyle(color: Colors.white),
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
    String? setBuyerresponse = await noteController.setBuyer(id, address);

    checkResponse(setBuyerresponse, context);
    if (setBuyerresponse != null && !setBuyerresponse.contains('Error')) {
      setState(() {
        supply.isBuyerAdded = true;
      });
    }
  }

  void addNewTransporter(String id, String address) async {
    String? setBuyerresponse = await noteController.setTransporter(id, address);

    checkResponse(setBuyerresponse, context);
    if (setBuyerresponse != null && !setBuyerresponse.contains('Error')) {
      setState(() {
        supply.isTransporterAdded = true;
      });
    }
  }

  void addNewInsurance(String id, String address) async {
    String? setBuyerresponse = await noteController.setInsurance(id, address);

    checkResponse(setBuyerresponse, context);
    if (setBuyerresponse != null && !setBuyerresponse.contains('Error')) {
      setState(() {
        supply.isInsuranceAdded = true;
      });
    }
  }

  Widget addSpacing() {
    if (!openedCard)
      return SizedBox(
        height: 0,
      );
    else {
      return Container(
        height: 2,
        color: Colors.grey.shade100,
      );
    }
  }
}

checkResponse(String? response, BuildContext context) {
  if (response == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error ! Try Again !!")));
  } else {
    print("\n________________________________");
    print("Added : $response");
    print("\n________________________________");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Added Successfully !")));
  }
}
