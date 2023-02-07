import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> getType(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(uid).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['type'];
    } catch (e) {
      return 'Error Fetching User';
    }
  }

  Future<String?> getName(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(uid).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['name'];
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
}
