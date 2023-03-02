import 'package:flutter/material.dart';
import 'package:supplychain/LogInPage.dart';
import 'package:supplychain/LogInPage.dart';
import 'package:supplychain/utils/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplychain/pages/dashboard.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

Route routeToDashboard(BuildContext context) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(),
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

Route routeToProfile(User user, String name, String type) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(
      user: user,
      name: name,
      type: type,
    ),
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
