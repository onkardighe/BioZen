import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:supplychain/utils/supply.dart';
import 'package:supplychain/utils/constants.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class NoteController extends ChangeNotifier {
  List<Supply> notes = [];
  bool isLoading = true;
  late int noteCount;
  final String _rpcUrl = goreli_url;
  final String _wsUrl = ws_url;

  final String _privateKey = privateKey;

  late Web3Client _client;
  late String _abiStringFile;

  late Credentials _credentials;
  late EthereumAddress _contractAddress;
  late DeployedContract _contract;
  // getestimated gas price
  late EtherAmount _gasPrice;

  late ContractFunction _getSupplies;
  late ContractFunction _notes;
  late ContractFunction _addSupply;
  late ContractFunction _deleteNote;
  late ContractFunction _editNote;
  late ContractEvent _noteAddedEvent;
  late ContractEvent _noteDeletedEvent;

  NoteController() {
    init();
  }

  init() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCreadentials();
    await getDeployedContract();
    _gasPrice = await _client
        .getBlockInformation()
        .then((value) => value.baseFeePerGas!);

    // var _basePrice   = await _client.get
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
    _getSupplies = _contract.function("getSupplies");
    _notes = _contract.function("getSupply");
    _addSupply = _contract.function("addSupply");

    // _noteAddedEvent = _contract.event("NoteAdded");
    // _noteDeletedEvent = _contract.event("NoteDeleted");
    await getNotes();
  }

  getNotes() async {
    try {
      List response = await _client
          .call(contract: _contract, function: _getSupplies, params: []);
      if (response.length == 0) {
        return;
      }
      List<dynamic> notesList = response[0];

      print(notesList.toString());
      noteCount = notesList.length;
      notes.clear();
      for (List<dynamic> note in notesList) {
        Supply n = Supply(
            id: note[0].toString(),
            title: note[1],
            body: note[2].toString(),
            created: DateTime(2021, 10, 10));
        notes.add(n);
        print(note.toString());
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
    return notes;
  }

  // addNote(Supply note) async {
  //   isLoading = true;
  //   notifyListeners();
  //   await _client.sendTransaction(
  //     _credentials,
  //     Transaction.callContract(
  //       contract: _contract,
  //       function: _addNote,
  //       parameters: [
  //         note.title,
  //         note.body,
  //         BigInt.from(note.created.millisecondsSinceEpoch),
  //       ],
  //     ),
  //   );
  //   await getNotes();
  // }

  Future<String> addSupply(String name, double quantity, double temp) async {
    List<dynamic> args = [name, BigInt.from(quantity)];
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
        chainId: 5,
      );

      await getNotes();

      isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      print("Error : ${e.toString()}");
      isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }
}
// 14859823512
// 15719886407
// 1000000000

// 10676151141
// 11392108090