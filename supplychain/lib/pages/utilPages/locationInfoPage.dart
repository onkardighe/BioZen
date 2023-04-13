import 'package:flutter/material.dart';
import 'package:supplychain/utils/appTheme.dart';

import '../../utils/supply.dart';

class LocationInfoPage extends StatefulWidget {
  final Supply _supply;
  final String _destination;
  final _history;

  const LocationInfoPage(
      {super.key,
      required Supply supply,
      required String destination,
      required var history})
      : _supply = supply,
        _destination = destination,
        _history = history;

  @override
  State<LocationInfoPage> createState() => _LocationInfoPageState();
}

class _LocationInfoPageState extends State<LocationInfoPage> {
  late Supply supply;
  late String destination = "";
  late List<dynamic> history;

  @override
  void initState() {
    supply = widget._supply;
    destination = widget._destination;
    history = widget._history;

    updateHistory();
    super.initState();
  }

  updateHistory() {
    if (history.last != "") {
      history.addAll([""]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_circle_left_rounded,
                color: Colors.white, size: 36),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(
                        MediaQuery.of(context).size.width * .1,
                      ),
                      height: MediaQuery.of(context).size.height * .15,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              blurStyle: BlurStyle.normal)
                        ],
                        color: AppTheme.secondaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "From",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(history.first,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          Icon(
                            Icons.fast_forward_sharp,
                            color: Colors.white,
                            size: 35,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("To", style: TextStyle(color: Colors.white)),
                              Text(destination,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * .1,
                      ),
                      height: MediaQuery.of(context).size.height * .15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(90)),
                          ),
                          Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(90)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Divider(
                    thickness: 1.5,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                Text("Location History",
                    style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Divider(
                    thickness: 1.5,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            for (var location in history)
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/road.png',
                                      scale: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        location == ""
                                            ? SizedBox()
                                            : Icon(
                                                Icons.location_on,
                                                color: Colors.amber,
                                                size: 40,
                                              ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          location,
                                          style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ])),
                      Container(
                        padding: EdgeInsets.only(
                            left: 50, top: history.length > 1 ? 100 : 0),
                        child: Image.asset(
                          'assets/vehicle-top-view.png',
                          scale: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
