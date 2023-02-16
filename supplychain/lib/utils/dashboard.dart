import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supplychain/utils/appTheme.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _selectedTag = 0;

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme().themeGradient),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Stack(
                      children: [
                        Align(
                          child: Text(
                            "Dashboard",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          left: 15,
                          child: CustomIconButton(
                            child: const Icon(Icons.arrow_back),
                            height: 35,
                            width: 35,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        const Text(
                          "Supplies Added ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTabView(
                          index: _selectedTag,
                          changeTab: changeTab,
                        ),
                      ],
                    ),
                  ),
                  _selectedTag == 0 ? const PlayList() : const Description(),
                ],
              ),
            ),
          ),
          bottomSheet: BottomSheet(
            onClosing: () {},
            backgroundColor: Colors.transparent,
            enableDrag: false,
            builder: (context) {
              return const SizedBox(
                height: 80,
                child: EnrollBottomSheet(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  var myData = [
    {
      "fName": "Onkar",
      "lName": "Dighe",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Nadim",
      "lName": "Shah",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Om",
      "lName": "Kshirsagar",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "DhirajKumar",
      "lName": "Sonawane",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Mohit",
      "lName": "Ahire",
      "time": "01:00 PM",
      "date": "22/02/2022",
    },
    {
      "fName": "Shri",
      "lName": "subramaniam",
      "time": "01:00 PM",
      "date": "22/02/2022",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, __) {
          return const SizedBox(
            height: 20,
          );
        },
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        shrinkWrap: true,
        itemCount: myData.length,
        itemBuilder: (_, index) {
          return Column(children: [
            for (var thisData in myData)
              buildCard(thisData["fName"], myData.indexOf(thisData),
                  thisData["date"], thisData["time"])
          ]);
        },
      ),
    );
  }
}

Widget buildCard(String? str, int id, String? date, String? time) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Container(
        margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(5),
        width: 315,
        height: 85,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              blurStyle: BlurStyle.normal)
        ], color: Colors.white, borderRadius: BorderRadius.circular(90)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                  gradient: AppTheme().themeGradient, shape: BoxShape.circle),
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                child: Icon(
                  Icons.calculate_rounded,
                  size: 45,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Package id : ${id}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${str}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 75,
              width: 120,
              decoration: BoxDecoration(
                  gradient: AppTheme().themeGradient,
                  borderRadius: BorderRadius.circular(90)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(time!, style: TextStyle(color: Colors.white)),
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      date!,
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
            )
          ],
        ),
      ),
    ],
  );
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

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .12, vertical: 15),
        decoration: BoxDecoration(
          color: widget.index == index ? Colors.deepPurple : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _tags[index],
          style: TextStyle(
            fontSize: 15,
            color: widget.index != index ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tags
            .asMap()
            .entries
            .map((MapEntry map) => _buildTags(map.key))
            .toList(),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: CustomIconButton(
              onTap: () {},
              color: Colors.deepPurple,
              height: 45,
              width: 45,
              child: Row(children: [
                SizedBox(width: 55.0),
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 30.0),
                Text(
                  "Add Supplies",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ]),
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
