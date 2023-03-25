import 'package:flutter/material.dart';
import 'package:supplychain/pages/HomePage.dart';
import 'package:supplychain/pages/LogInPage.dart';
import 'package:supplychain/pages/profilePage.dart';
import 'package:supplychain/pages/dashboard.dart';
import 'package:supplychain/pages/ListCards.dart';
import 'package:supplychain/services/supplyController.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:supplychain/utils/AlertBoxes.dart';
import 'package:supplychain/services/DatabaseService.dart';

import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

checkResponse(String? response, BuildContext context,
    SupplyController supplyController) async {
  print("Response : $response");
  if (response == null) {
    showRawAlert(context, "Error ! Try Again !!");
  } else {
    print("\n________________________________");
    print("Added : $response");
    print("\n________________________________");
    showRawAlert(context, "Added Successfully !");
    await supplyController.getSuppliesOfUser();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// ROUTES ///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Route routeToHomePage(BuildContext context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(-1, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route routeToDashboard(BuildContext context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const DashboardScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route routeToProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const ProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route routeToLogInScreen() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => LogInPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// REGULAR FUNCTIONS ///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

displayAllBidders(BuildContext context, String supplyId) async {
  var bidders = await DatabaseService.getBidders(supplyId);
  if (bidders == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching bidders for Supply ID : ${supplyId}")));
  } else {
    var response = await ListCard.bidderListCard(context, bidders, "Bidder");
    return response;
  }
}

displayAllTransporters(BuildContext context) async {
  List? transporters =
      await DatabaseService.getUsersByType('Transport Authority');
  if (transporters == null) {
    print("no users found");
  } else {
    var response =
        await ListCard.userListCard(context, transporters, "Transporter");
    return response;
  }
}

displayAllInsurers(BuildContext context) async {
  List? insurers = await DatabaseService.getUsersByType('Insurance Authority');
  if (insurers == null) {
    print("no users found");
  } else {
    var response = await ListCard.userListCard(context, insurers, "Insurer");
    return response;
  }
}

displayAllOpenSupplies(BuildContext context) async {
  await ListCard.supplyListCard(context, "Select biofuel to buy");
}

displayListSpecificSupplies(
    BuildContext context, var list, String? title) async {
  if (title == null) {
    await ListCard.userSupplyListCard(context, "Explore Supply", supplyList: list);
  } else {
    await ListCard.userSupplyListCard(context, title, supplyList: list);
  }
}
