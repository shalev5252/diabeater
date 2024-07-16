import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabeater/models/app_users.dart';

class DatabaseService {
  //collection reference
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future setUserData(String name, String mail, DateTime birthday, String phone,
      bool mentor) async {
    AppUser user = AppUser(
        mail: mail,
        name: name,
        phone_number: phone,
        mentor: mentor,
        birthday: birthday);
    return await usersCollection.doc(uid).set(user.toJson());
  }

  Future updateUserData(
      String name, String mail, DateTime birthday, String phone) async {
    return await usersCollection.doc(uid).update(
        {'name': name, 'birthday': birthday, 'phone': phone, 'mail': mail});
  }

  Future updateUserbackgroundPic(String pic, bool is_background) async {
    if (is_background)
      return await usersCollection.doc(uid).update({'backgroundPicUrl': pic});
    else {
      return await usersCollection.doc(uid).update({'profilePicUrl': pic});
    }
  }

  List<AppUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    print(snapshot.docs.length); // return 0.
    // print(snapshot.docs.toString()); // here this returns [].
    return snapshot.docs.map((doc) {
      return AppUser.fromServer(
        doc['mail'] as String,
        doc['name'] as String,
        doc['phone'] as String,
        doc['isMentor'] as bool,
        doc['backgroundPicUrl'] as String,
        doc['profilePicUrl'] as String,
        DateTime.parse(doc['birthday'] as String),
        false,
      );
    }).toList();
  }

  Stream<List<AppUser>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }
}
