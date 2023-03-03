import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> fetchDataOfUser(String uid, field) async
  {
    try {
      var users = FirebaseFirestore.instance.collection('users');
      var snapshot = await users.doc(uid).get();

      var data = snapshot.data() as Map<String, dynamic>;
      return data[field];
    } catch (e) {
      print("Exception : {$e}");
      return 'Error Fetching $field';
    }
  }

  Future<String?> getNameByAddress(String address) async {
    try {
      String uid = await getUidByPublicAddress(address);
      if (uid.contains('Error')) {
        return 'Error Fetching UserID';
      } else {
        String? name = await fetchDataOfUser(uid, 'name');
        return name;
      }
    } catch (e) {
      return 'Error Fetching User';
    }
  }

  static updateUserType(String uid, type) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'type': type});
  }

  static setMobileNumber(String uid, mobileNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'mobile': mobileNumber});
  }

  static getMobileNumber(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(uid).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['mobile'];
    } catch (e) {
      return 'Error Fetching Mobile';
    }
  }

  static getUidByPublicAddress(String sAddress) async {
    try {
      CollectionReference usersByAddress =
          FirebaseFirestore.instance.collection("usersByAddress");

      var ss = await usersByAddress.doc(sAddress).get();
      final data = ss.data() as Map<String, dynamic>;
      return data['uid'];
    } catch (e) {
      print("Error ${e.toString()}");
      return 'Error Fetching User';
    }
  }

  static setPrivateAddress(String uid, privateAddress) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'privateAddress': privateAddress});
  }
}
