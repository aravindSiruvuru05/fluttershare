import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String displayname;
  final String bio;

  User({
    this.id,
    this.username,
    this.photoUrl,
    this.email,
    this.displayname,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      displayname: doc['displayname'],
      bio: doc['bio'],
    );
  }
}
