import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
// import 'package:supplychain/services/functions.dart';
import 'package:supplychain/utils/supply.dart';
import 'package:supplychain/utils/constants.dart';
// import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class SupplyController extends ChangeNotifier {
  List<Supply> allSupplies = [];
  List<Supply> userSupply = [];
  bool isLoading = false;
  late int noteCount;
  final String _rpcUrl = goreli_url;
  final String _wsUrl = ws_url;

  late Web3Client _client;
  late String _abiStringFile;

  late Credentials _credentials;
  late EthereumAddress _contractAddress;
  late DeployedContract _contract;
  // get estimated/updated gas price
  late EtherAmount _gasPrice;

  late ContractFunction _addSupply;
  late ContractFunction _completeSupply;
  late ContractFunction _getSupply;
  late ContractFunction _getSupplies;
  late ContractFunction _getUserSupplies;
  late ContractFunction _totalSupplies;

  late ContractFunction _addBuyer;
  late ContractFunction _addTransporter;
  late ContractFunction _addInsurance;

  late ContractFunction _getBuyerFunction;
  late ContractFunction _getTransporterFunction;
  late ContractFunction _getInsuranceFunction;

  late ContractFunction _getLocationHistory;
  late ContractFunction _getDestination;
  late ContractFunction _updateLocation;

  late ContractEvent _noteAddedEvent;
  late ContractEvent _noteDeletedEvent;

  SupplyController() {
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCreadentials();
    await getDeployedContract();
    _updateGasPrice();
  }

  _updateGasPrice() async {
    await _client.getBlockInformation().then((value) {
      _gasPrice = value.baseFeePerGas!;
      return _gasPrice;
    });
  }

  Future<void> getAbi() async {
    _abiStringFile = await rootBundle.loadString("assets/abi.json");
  }

  Future<void> getCreadentials() async {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<void> getDeployedContract() async {
    _contractAddress = EthereumAddress.fromHex(deployedContractAddress);
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiStringFile, "Storage"), _contractAddress);
    _addSupply = _contract.function("addSupply");
    _completeSupply = _contract.function("completeSupply");

    _getSupply = _contract.function("getSupply");
    _getSupplies = _contract.function("getSupplies");
    _getUserSupplies = _contract.function("getSuppliesOfUser");
    _totalSupplies = _contract.function("totalSupplies");

    _addBuyer = _contract.function("addBuyer");
    _addTransporter = _contract.function("addTransporter");
    _addInsurance = _contract.function("addInsurance");

    _getBuyerFunction = _contract.function("getBuyer");
    _getTransporterFunction = _contract.function("getTransporter");
    _getInsuranceFunction = _contract.function("getInsurance");

    _getLocationHistory = _contract.function("getLocationHistory");
    _getDestination = _contract.function("getDestination");
    _updateLocation = _contract.function("addCurrentLocation");

    // _noteAddedEvent = _contract.event("NoteAdded");
    // _noteDeletedEvent = _contract.event("NoteDeleted");
    await getNotes();
    await getSuppliesOfUser();
  }

  getNotes() async {
    // isLoading = true;
    notifyListeners();
    try {
      List response = await _client
          .call(contract: _contract, function: _getSupplies, params: []);
      if (response.length == 0) {
        isLoading = false;
        notifyListeners();
        return;
      }
      List<dynamic> notesList = response[0];

      noteCount = notesList.length;
      allSupplies.clear();

      for (List<dynamic> note in notesList) {
        Supply n = Supply(
          id: note[0].toString(),
          title: note[1],
          quantity: note[2].toString(),
          temperature: note[3].toString(),
          supplierAddress: note[4],
          createdAt: DateTime.parse(note[5]),
          initiated: note[6],
          isBuyerAdded: note[7],
          isTransporterAdded: note[8],
          isInsuranceAdded: note[9],
          isCompleted: note[10],
        );
        allSupplies.add(n);
        print(note.toString());
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
    return allSupplies;
  }

  getSupplyByID(BigInt id) async {
    // isLoading = true;
    // notifyListeners();
    try {
      List response = await _client
          .call(contract: _contract, function: _getSupply, params: [id]);
      if (response.isEmpty) {
        isLoading = false;
        notifyListeners();
        return;
      }
      List<dynamic> supply = response[0];
      Supply newSypply = Supply(
        id: supply[0].toString(),
        title: supply[1],
        quantity: supply[2].toString(),
        temperature: supply[3].toString(),
        supplierAddress: supply[4],
        createdAt: DateTime.parse(supply[5]),
        initiated: supply[6],
        isBuyerAdded: supply[7],
        isTransporterAdded: supply[8],
        isInsuranceAdded: supply[9],
        isCompleted: supply[10],
      );
      isLoading = false;
      notifyListeners();
      return newSypply;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  getSuppliesOfUser() async {
    isLoading = true;
    notifyListeners();
    try {
      List response = await _client.call(
          contract: _contract,
          function: _getUserSupplies,
          params: [EthereumAddress.fromHex(publicKey)]);
      isLoading = false;

      if (response.isEmpty) {
        isLoading = false;
        notifyListeners();
        return;
      }
      var userSupplyIDList = response[0];

      userSupply.clear();

      var uniqueSupplies = <dynamic>{};
      userSupplyIDList.forEach((supply) {
        uniqueSupplies.add(supply);
      });

      for (var supplyID in uniqueSupplies) {
        var newSupply = await getSupplyByID(supplyID);
        userSupply.add(newSupply);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  addSupply(String name, double quantity, double temp, String sourceLocation,
      String currentStamp) async {
    await getCreadentials();
    return await _updateGasPrice().then((res) async {
      print("Enteres");
      publicKey = _credentials.address.toString();
      List<dynamic> args = [
        name,
        BigInt.from(quantity),
        BigInt.from(temp),
        EthereumAddress.fromHex(publicKey),
        currentStamp,
        sourceLocation
      ];
      try {
        isLoading = true;
        notifyListeners();
        String response = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            gasPrice: _gasPrice,
            contract: _contract,
            function: _addSupply,
            parameters: args,
          ),
          chainId: 0xaa36a7,
        );

        isLoading = false;
        notifyListeners();
        print("Added : ${response.toString()}");
        return response;
      } catch (e) {
        print("Error : ${e.toString()}");
        isLoading = false;
        notifyListeners();
      }
    });
  }

  completeSupply(String id, String timeCompleted) async {
    isLoading = true;
    getCreadentials();
    _updateGasPrice();

    List<dynamic> args = [BigInt.from(int.parse(id)), timeCompleted];

    try {
      String response = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          gasPrice: _gasPrice,
          contract: _contract,
          function: _completeSupply,
          parameters: args,
        ),
        chainId: 0xaa36a7,
      );
      isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      print("Error while completing Supply : ${e.toString()}");
      isLoading = false;
      notifyListeners();
    }
  }

  setBuyer(String id, String buyerAddress, String destination) async {
    isLoading = true;
    getCreadentials();
    _updateGasPrice();

    List<dynamic> args = [
      BigInt.from(int.parse(id)),
      EthereumAddress.fromHex(buyerAddress, enforceEip55: true),
      destination
    ];

    try {
      String response = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          gasPrice: _gasPrice,
          contract: _contract,
          function: _addBuyer,
          parameters: args,
        ),
        chainId: 0xaa36a7,
      );
      isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      print("Error while selecting Buyer : ${e.toString()}");
      isLoading = false;
      notifyListeners();
    }
  }

  setTransporter(String id, String transporterAddress) async {
    isLoading = true;
    getCreadentials();
    return await _updateGasPrice().then((gasPrice) async {
      List<dynamic> args = [
        BigInt.from(int.parse(id)),
        EthereumAddress.fromHex(transporterAddress)
      ];

      try {
        String response = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            gasPrice: _gasPrice,
            contract: _contract,
            function: _addTransporter,
            parameters: args,
          ),
          chainId: 0xaa36a7,
        );

        isLoading = false;
        notifyListeners();
        return response;
      } catch (e) {
        print("Error while selecting Transporter : ${e.toString()}");
        isLoading = false;
        notifyListeners();
      }
    });
  }

  setInsurance(String id, String insuranceAddress) async {
    isLoading = true;
    getCreadentials();
    _updateGasPrice();
    List<dynamic> args = [
      BigInt.from(int.parse(id)),
      EthereumAddress.fromHex(insuranceAddress)
    ];

    try {
      String response = await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          gasPrice: _gasPrice,
          contract: _contract,
          function: _addInsurance,
          parameters: args,
        ),
        chainId: 0xaa36a7,
      );

      isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      isLoading = false;
      print("Error while selecting Insurence : ${e.toString()}");
    }
  }

  getSubscribers(BigInt id, String userType) async {
    // isLoading = true;

    ContractFunction contractFunction;
    if (userType == fuelCompany) {
      contractFunction = _getBuyerFunction;
    } else if (userType == insuranceAuthority) {
      contractFunction = _getInsuranceFunction;
    } else if (userType == transportAuthority) {
      contractFunction = _getTransporterFunction;
    } else {
      contractFunction = _getBuyerFunction;
    }

    try {
      var response = await _client
          .call(contract: _contract, function: contractFunction, params: [id]);
      if (response.isEmpty) {
        isLoading = false;
        return;
      }
      isLoading = false;
      return response[0];
    } catch (e) {
      isLoading = false;
      var res = e.toString();
      if (res.contains("$userType is NOT added !!")) {
        print(res);
        return "Not selected";
      }
    }
  }

  getLocationHistory(BigInt id) async {
    // isLoading = true;
    notifyListeners();
    try {
      var response = await _client.call(
          contract: _contract, function: _getLocationHistory, params: [id]);
      if (response.isEmpty) {
        isLoading = false;
        return;
      }
      isLoading = false;
      return response[0];
    } catch (e) {
      isLoading = false;
      var res = e.toString();
      print(res);
    }
  }

  getTotalNumberOfSupplies() async {
    // isLoading = true;
    notifyListeners();

    try {
      var response = await _client
          .call(contract: _contract, function: _totalSupplies, params: []);
      if (response.isEmpty) {
        isLoading = false;
        return;
      }
      isLoading = false;
      return int.tryParse(response[0].toString());
    } catch (e) {
      isLoading = false;
      var res = e.toString();
      print(res);
    }
  }

  getDestination(BigInt id) async {
    // isLoading = true;
    try {
      var response = await _client
          .call(contract: _contract, function: _getDestination, params: [id]);
      if (response.isEmpty) {
        isLoading = false;
        return;
      }
      isLoading = false;

      return response[0];
    } catch (e) {
      isLoading = false;
      var res = e.toString();
      print(res);
    }
  }

  updateLocation(String id, String currentAddress) async {
    isLoading = true;
    notifyListeners();
    getCreadentials();
    return await _updateGasPrice().then((resp) async {
      List<dynamic> args = [BigInt.from(int.parse(id)), currentAddress];

      try {
        String response = await _client.sendTransaction(
          _credentials,
          Transaction.callContract(
            gasPrice: _gasPrice,
            contract: _contract,
            function: _updateLocation,
            parameters: args,
          ),
          chainId: 0xaa36a7,
        );

        isLoading = false;
        notifyListeners();
        return response;
      } catch (e) {
        isLoading = false;
        notifyListeners();
        print("Error while Updating Location : ${e.toString()}");
      }
    });
  }
}
