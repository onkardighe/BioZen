import 'package:firebase_auth/firebase_auth.dart';

String goreli_url =
    'https://eth-goerli.g.alchemy.com/v2/UEaVuX0SQSuYOZ0JyVYBfRRfqRN4vfWU';

String ws_url =
    'wss://eth-goerli.g.alchemy.com/v2/UEaVuX0SQSuYOZ0JyVYBfRRfqRN4vfWU';

String privateKey = '';
// '0x0d12481ebecd4132d9f79b60d7a86b38c8a60ab59f2a42b596db02d7bb4e4737';

String publicKey = '0xc6657756dbd79B760Bd27298cd6eB6B040946097';

// String deployedContractAddress = '0xf0cE6395B1369cd471408Bd7eFCB7ebbbc2e764b';
String deployedContractAddress = '0x2f5EC9271236C698C8f077ee2f6722A719244fE4';

bool privateKeyLinked = false;

// ---------------- User Data --------------------//
late User user;
late String userType = '';
String? mobileNumber = null;
String email = "";

// ---------------- Names of Users --------------------//
String fuelCompany = "Fuel Company";
String supplier = "Supplier";
String transportAuthority = "Transport Authority";
String insuranceAuthority = "Insurance Authority";
