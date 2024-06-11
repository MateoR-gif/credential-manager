import 'package:app/models/MyUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final String collection = "users";

  Future<String?> createUser(MyUser user) async {
    try {
      await db.collection(collection).doc(user.id).set(user.toJson());
      return user.id;
    } catch (e) {
      print(e);
      return "";
    }
  }

}