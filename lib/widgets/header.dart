import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false,
    String titleText,
    bool isbackButtonRemoved = false}) {
  return AppBar(
    automaticallyImplyLeading: isbackButtonRemoved,
    title: Text(
      isAppTitle ? "Fluttershare" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 50.0 : 22.0,
      ),
    ),
    backgroundColor: Theme.of(context).accentColor,
  );
}
