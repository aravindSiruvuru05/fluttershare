import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool _isLoading = false;
  User user;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayname;
    bioController.text = user.bio;
    setState(() {
      _isLoading = false;
    });
  }

  buildEditPage() {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
          child: Center(
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              radius: 50.0,
            ),
          ),
        ),
        buildDisplayNameTextField(),
        buildDBioTextField(),
        Center(
          child: RaisedButton(
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Center(
          child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel, color: Colors.red),
                Text(
                  "logout",
                  style: TextStyle(color: Colors.red, fontSize: 20.0),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildDisplayNameTextField() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Display Name"),
          TextFormField(
            controller: displayNameController,
            decoration: InputDecoration(
              hintText: "Display Name",
            ),
          )
        ],
      ),
    );
  }

  buildDBioTextField() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bio"),
          TextFormField(
            controller: bioController,
            decoration: InputDecoration(
              hintText: "Bio",
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.check,
                color: Colors.green,
                size: 40.0,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading ? circularProgress() : buildEditPage(),
    );
  }
}
