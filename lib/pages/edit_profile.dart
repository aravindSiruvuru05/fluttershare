import 'dart:async';

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
  bool _isbioValid = true;
  bool _isdisplayNameValid = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  updateProfileData() {
    setState(() {
      displayNameController.text.length < 3 ||
              displayNameController.text.isEmpty
          ? _isdisplayNameValid = false
          : _isdisplayNameValid = true;

      bioController.text.length < 3 || bioController.text.isEmpty
          ? _isbioValid = false
          : _isbioValid = true;
    });

    if (_isbioValid && _isdisplayNameValid) {
      usersRef.document(widget.currentUserId).updateData({
        "displayname": displayNameController.text,
        "bio": bioController.text
      });
      Navigator.pop(context, "Profile Updated");
//      SnackBar snackBar = SnackBar(
//        content: Text("profile Updated"),
//      );
//      _scaffoldKey.currentState.showSnackBar(snackBar);
//      Timer(Duration(seconds: 2), () {
//
//      });
    }
  }

  logoutHandle() {
    googleSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
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
            onPressed: updateProfileData,
            child: Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: FlatButton.icon(
              onPressed: logoutHandle,
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              label: Text(
                "logout",
                style: TextStyle(color: Colors.red),
              )),
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
                errorText: _isdisplayNameValid
                    ? null
                    : "displayname shud be greater than 3 chars"),
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
              errorText: _isdisplayNameValid
                  ? null
                  : "displayname shud be greater than 3 chars",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                Icons.clear,
                color: Colors.red,
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
