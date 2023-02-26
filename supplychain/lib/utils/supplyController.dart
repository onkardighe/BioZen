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

  late ContractFunction _notesCount;
  late ContractFunction _notes;
  late ContractFunction _addNote;
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
    _notesCount = _contract.function("getSupplies");
    _notes = _contract.function("getSupply");
    _addNote = _contract.function("addSupply");

    // _noteAddedEvent = _contract.event("NoteAdded");
    // _noteDeletedEvent = _contract.event("NoteDeleted");
    await getNotes();
  }

  getNotes() async {
    List response = await _client
        .call(contract: _contract, function: _notesCount, params: []);
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

    // for (int i = 0; i < noteCount; i++) {
    //   var temp = await _client.call(
    //       contract: _contract, function: _notes, params: [BigInt.from(i)]);
    //   if (temp[1] != "")
    //     notes.add(
    //       Note(
    //         id: temp[0].toString(),
    //         title: temp[1],
    //         body: temp[2],
    //         created:
    //             DateTime.fromMillisecondsSinceEpoch(temp[3].toInt() * 1000),
    //       ),
    //     );
    // }
    isLoading = false;
    notifyListeners();
  }

  addNote(Supply note) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _addNote,
        parameters: [
          note.title,
          note.body,
          BigInt.from(note.created.millisecondsSinceEpoch),
        ],
      ),
    );
    await getNotes();
  }
}
