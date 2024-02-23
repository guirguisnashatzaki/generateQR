import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markfayezenter/clientObject.dart';

class MyFireStore{

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(MyClient clientObject) {
    // Call the user's CollectionReference to add a new user
    return users
        .add(clientObject.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}