import 'package:flutter/material.dart';
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

Route routeToDashboard(BuildContext context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DashboardScreen(),
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
    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
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
///////////////////////////////////////// FUNCTIONS FOR BLOCKCHAIN ///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');

  String contractAddress = deployedContractAddress;

  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Storage'),
      EthereumAddress.fromHex(contractAddress));

  return contract;
}

Future<String> callFunction(String functionName, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);

  DeployedContract contract = await loadContract();

  final ethFunction = contract.function(functionName);
  // print("Parameters given are ${args}");

  try {
    final trasnID = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: 5,
    );
    return trasnID;
  } catch (e) {
    print(e);
    return "Error" + e.toString();
  }
}

getAllSupplies(Web3Client ethClient) async {
  DeployedContract contract = await loadContract();

  final ethFunction = contract.function("getAllSupplies");

  final result = await ethClient
      .call(contract: contract, function: ethFunction, params: []);
  print("All Supplies are ${result[0]}");
  print("_______________________________________________________");
  return result[0];
}

Future<int> getTotalSupplies(Web3Client ethClient) async {
  DeployedContract contract = await loadContract();

  final ethFunction = contract.function("totalSupplies");

  final result = await ethClient
      .call(contract: contract, function: ethFunction, params: []);
  var ans = result[0].toInt();
  print("Total Supplies are $ans");
  print("_______________________________________________________");
  return ans;
}

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
  List? transporters =
      await DatabaseService.getUsersByType('Insurance Authority');
  if (transporters == null) {
    print("no users found");
  } else {
    var response =
        await ListCard.userListCard(context, transporters, "Insurer");
    return response;
  }
}

displayAllOpenSupplies(BuildContext context) async {
  await ListCard.supplyListCard(context, "Select biofuel to buy");

}
