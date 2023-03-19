import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> fetchDataOfUser(String uid, field) async {
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

  static Future<List?> getUsersByType(String type) async {
    try {
      var users = FirebaseFirestore.instance.collection('users');
      var userList = await users.where('type', isEqualTo: type).get();

      var list = [];
      for (var element in userList.docs) {
        var user = element.data();
        list.add(user);
      }

      return list;
    } catch (e) {
      print("Exception : {$e}");
      return null;
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////  BIDDING PROCESS ///////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  static void makeBid(String supplyId, String address, int price) async {
    var dbSnap = FirebaseFirestore.instance.collection('bids').doc(supplyId);
    var doc = await dbSnap.get();

    if (doc.exists) {
      await dbSnap.update({address: price});
    } else {
      await dbSnap.set({address: price});
    }
  }

  static Future<bool> isBidderPresent(
      String supplyId, String bidderAddress) async {
    var dbSnap = FirebaseFirestore.instance.collection('bids').doc(supplyId);
    var doc = await dbSnap.get();

    if (doc.exists) {
      var docList = doc.data() as Map<String, dynamic>;
      return docList.containsKey(bidderAddress);
    } else {
      return false;
    }
  }

  static Future<Map> getBidders(String supplyId) async {
    var biddedSupplies =
        FirebaseFirestore.instance.collection('bids').doc(supplyId);
    var doc = await biddedSupplies.get();

    if (doc.exists) {
      var docList = doc.data() as Map<String, dynamic>;
      return docList;
    }
    return Map<String, dynamic>();
  }
}
