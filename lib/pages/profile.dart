import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/edit_profile.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  buildCountColumn(label, value) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                label,
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: currentUser.id),
      ),
    );
    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("$result")));
    } else {
      Scaffold.of(context)..removeCurrentSnackBar();
    }
  }

  buildEditProfileButton() {
    return FlatButton(
      onPressed: handleEditProfile,
      child: Container(
        width: 250.0,
        height: 27.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          "Edit Your Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.only(left: 15, right: 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    backgroundColor: Colors.grey,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCountColumn("Followers", "20"),
                            buildCountColumn("Posts", "20"),
                            buildCountColumn("Following", "20"),
                          ],
                        ),
                        buildEditProfileButton()
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.username,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0, left: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.displayname,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, left: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.bio,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: ListView(
        children: [
          buildProfileHeader(),
          Divider(),
        ],
      ),
    );
  }
}
