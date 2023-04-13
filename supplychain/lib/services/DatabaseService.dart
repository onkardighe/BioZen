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

  static addSupplyToDB(String supplyId, String currDateTime) async {
    var docRef =
        FirebaseFirestore.instance.collection('completed').doc(supplyId);
    var doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'buyerReceived': false,
        'completedAt': currDateTime,
        'insurerVerified': false,
        'markedAsCompleted': false,
        'transportDelivered': false
      });
    }
  }

  static verifySupplyToComplete(String supplyId, String type) async {
    var docRef =
        FirebaseFirestore.instance.collection('completed').doc(supplyId);

    var doc = await docRef.get();

    var fieldsValue = Map<String, dynamic>();

    var field;
    if (type == fuelCompany) {
      fieldsValue.addAll({"buyerReceived": true});
    } else if (type == supplier) {
      fieldsValue.addAll({"markedAsCompleted": true});
    } else if (type == transportAuthority) {
      fieldsValue.addAll({
        "buyerReceived": false,
        "markedAsCompleted": false,
        "transportDelivered": true,
        "insurerVerified": false,
        "completedAt": DateTime.now().toString()
      });
    } else if (type == insuranceAuthority) {
      fieldsValue.addAll({"insurerVerified": true});
    } else {
      return false;
    }

    // var checks = type == transportAuthority
    //     ? {field: true, "completedAt": DateTime.now().toString()}
    //     : {field: true};

    if (doc.exists) {
      await docRef.update(fieldsValue);
    } else {
      await docRef.set({field: true});
    }
    return true;
  }

  static getSupplydeliveryStatus(String supplyId) async {
    var docData = await FirebaseFirestore.instance
        .collection('completed')
        .doc(supplyId)
        .get();
    if (!docData.exists) {
      return null;
    }
    return docData.data() as Map<String, dynamic>;

    // print(data.toString());
  }

  static getSupplyIDsOfSelectedUser(String publicAddressUser,
      {required String type}) async {
    var docRef =
        FirebaseFirestore.instance.collection('selectedUsers').doc(type);
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

  static void makeBid(
      String supplyId, String address, int price, String destination) async {
    var dbSnap = FirebaseFirestore.instance
        .collection('bids')
        .doc('buyerBids')
        .collection(supplyId)
        .doc(address);
    var doc = await dbSnap.get();

    if (doc.exists) {
      await dbSnap.update({
        'bidderAddress': address,
        'bidPrice': price,
        'destination': destination
      });
    } else {
      await dbSnap.set({
        'bidderAddress': address,
        'bidPrice': price,
        'destination': destination
      });
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

  static getBidders(String supplyId) async {
    var supplyBidders = FirebaseFirestore.instance
        .collection('bids')
        .doc('buyerBids')
        .collection(supplyId);
    var doc = await supplyBidders.get();

    if (doc.docs.isNotEmpty) {
      var res = doc.docs.asMap();

      return res;
    }
    return null;
  }

  static getRating({required String address}) async {
    String uid = await getUidByPublicAddress(address);

    var userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    var user = userData.data();
    if (user != null) {
      return user['rating'] / user['ratingNumber'];
    }

    return null;
  }

  // Update Ratings of User

  static updateRating({required String address, required int ratings}) async {
    await getUidByPublicAddress(address).then((uid) async {
      var userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await userRef.get().then((user) async {
        var userData = user.data();
        if (user != null) {
          var prevRatings = user['rating'];
          var prevRatingsNumber = user['ratingNumber'];
          await userRef.update({
            'rating': (prevRatings + ratings) / 2,
            'ratingNumber': prevRatingsNumber += 1
          });
        }
      });
    });

    return null;
  }
}
