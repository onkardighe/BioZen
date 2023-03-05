import 'package:flutter/material.dart';
import 'package:supplychain/utils/appTheme.dart';

class UserListCard {
  static Future<dynamic> createUserListCard(
      BuildContext context, List users) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return UserListCards(
            suppliers: users,
          );
        });
  }
}

class UserListCards extends StatefulWidget {
  final List _users;
  const UserListCards({super.key, required List suppliers})
      : _users = suppliers;

  @override
  State<UserListCards> createState() => _UserListCards();
}

class _UserListCards extends State<UserListCards> {
  late List users;
  late List<Widget> userCards = [];
  bool selected = false;
  late String currentSelected;
  late var response = null;
  @override
  void initState() {
    users = widget._users;
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, response);
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
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: users.isEmpty
                        ? [Text("No Users Avaialble !")]
                        : userCards,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(selected ? currentSelected : "Select one From List !"),
                    GestureDetector(
                      onTap: () {
                        if (selected) {
                          Navigator.pop(context, response);
                        }
                      },
                      child: Icon(
                        Icons.check_circle,
                        size: 35,
                        color: selected ? AppTheme.primaryColor : Colors.grey,
                      ),
                    )
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
