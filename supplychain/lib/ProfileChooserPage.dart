import 'package:flutter/material.dart';

class ProfileChooserPage extends StatefulWidget {
  _ProfileChooserPageState createState() => _ProfileChooserPageState();
}

class _ProfileChooserPageState extends State<ProfileChooserPage> {
  double _cardHeight = 220, _cardWidth = 160;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Supply Chain",
          ),
        ),
        body: Center(
          child: Container(
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    "Are You ?",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.fromSize(
                        size: Size(_cardWidth, _cardHeight), // button width and height
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Material(
                            color: Colors.blueGrey.shade100, // button color
                            child: InkWell(
                              splashColor: Colors.blue, // splash color
                              onTap: () {}, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Spacer(),
                                  Icon(
                                    Icons.factory_rounded,
                                    size: 80,
                                  ),
                                  // Spacer(),
                                  Text(
                                    "Supplier",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox.fromSize(
                        size: Size(_cardWidth, _cardHeight), // button width and height
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Material(
                            color: Colors.blueGrey.shade100, // button color
                            child: InkWell(
                              splashColor: Colors.blue, // splash color
                              onTap: () {}, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Spacer(),
                                  Icon(
                                    Icons.local_gas_station_rounded,
                                    size: 80,
                                  ),
                                  // Spacer(),
                                  Text(
                                    "Fuel Company",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox.fromSize(
                        size: Size(_cardWidth, _cardHeight), // button width and height
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Material(
                            color: Colors.blueGrey.shade100, // button color
                            child: InkWell(
                              splashColor: Colors.blue, // splash color
                              onTap: () {}, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Spacer(),
                                  Icon(
                                    Icons.local_shipping_rounded,
                                    size: 80,
                                  ),
                                  // Spacer(),
                                  Text(
                                    "Transport Authority",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox.fromSize(
                        size: Size(_cardWidth, _cardHeight), // button width and height
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Material(
                            color: Colors.blueGrey.shade100, // button color
                            child: InkWell(
                              splashColor: Colors.blue, // splash color
                              onTap: () {}, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Spacer(),
                                  Icon(
                                    Icons.shield_rounded,
                                    size: 80,
                                  ),
                                  // Spacer(),
                                  Text(
                                    "Insurance Authority",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                                  // Text("📦  🏭 🚚 🛡", style: TextStyle(fontSize: 60),),
                  Spacer()
                ],
              ),
            ),
          ),
        );
  }

  void _buttonPressed() {}
}
