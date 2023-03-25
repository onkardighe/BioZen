import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplychain/utils/constants.dart';

class DatabaseService {
  static removeField(String collectionName, String docName, String fieldName) {
    var addressDoc = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docName)
        .update({fieldName: FieldValue.delete()});
  }

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
      var addressDoc =
          FirebaseFirestore.instance.collection("usersByAddress").doc(sAddress);

      var res = await addressDoc.get();
      final data = res.data() as Map<String, dynamic>;
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

  static selectInsurer(String supplyId, publicAddressInsurer) async {
    var docRef = FirebaseFirestore.instance
        .collection('selectedUsers')
        .doc(insuranceAuthority);

    var doc = await docRef.get();
    if (doc.exists) {
      await docRef.update({supplyId: publicAddressInsurer});
    } else {
      await docRef.update({supplyId: publicAddressInsurer});
    }
  }

  static selectTransporter(String supplyId, publicAddressTransporter) async {
    var docRef = FirebaseFirestore.instance
        .collection('selectedUsers')
        .doc(transportAuthority);

    var doc = await docRef.get();

    if (doc.exists) {
      await docRef.update({supplyId: publicAddressTransporter});
    } else {
      await docRef.set({supplyId: publicAddressTransporter});
    }
  }

  static getSupplyIDsOfSelectedUser(String publicAddressUser, {required String type}) async {
    var docRef = FirebaseFirestore.instance
        .collection('selectedUsers')
        .doc(type);
    var data = await docRef.get();
    late var userData = <String, dynamic>{};
    if (data.data() != null) {
      userData = data.data() as Map<String, dynamic>;
      userData.removeWhere(
        (key, value) {
          return value != publicAddressUser;
        },
      );
    }
    return userData.keys;
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
    try {
      var dbSnap = FirebaseFirestore.instance.collection('bids').doc(supplyId);
      var doc = await dbSnap.get();
      if (doc.exists) {
        var docList = doc.data() as Map<String, dynamic>;
        return docList.containsKey(bidderAddress);
      } else {
        return false;
      }
    } catch (exception) {
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
