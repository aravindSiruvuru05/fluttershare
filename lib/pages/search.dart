import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchResultsFuture;

  TextEditingController textEditingController = TextEditingController();

  handleSearch(searchText) {
    Future<QuerySnapshot> users = usersRef
        .where("displayname", isGreaterThanOrEqualTo: searchText)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    textEditingController.clear();
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: "seach here...",
          filled: true,
          prefixIcon: Icon(Icons.account_box, size: 28.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              'Find Users .. ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: orientation == Orientation.portrait ? 50.0 : 40.0),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder buildSearchResutls() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          print(snapShot);
          return circularProgress();
        }
        print(snapShot.data.documents.length);
        List<UserResult> searchResults = [];
        snapShot.data.documents.forEach((doc) {
          User searchResult = User.fromDocument(doc);
          searchResults.add(UserResult(searchResult));
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: buildSearchField(),
      body:
          searchResultsFuture != null ? buildSearchResutls() : buildNoContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            ),
            title: Text(
              user.displayname,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              user.username,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
