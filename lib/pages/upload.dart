import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

import '../widgets/progress.dart';

class Upload extends StatefulWidget {
  final User currentUser;

  Upload({this.currentUser});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String urll = "";
  File _image;
  bool _isUploading = false;
  String postId = Uuid().v4();

  final picker = ImagePicker();

  handleTakePhoto() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  handleChooseImage() async {
    Navigator.pop(context);
    print("handle choose");
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 255);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<String> uploadPhoto(image) async {
    StorageUploadTask uploadTask =
        storageRef.child("post_$postId.jpeg").putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String dowloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowloadUrl;
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      _image = compressedImageFile;
    });
  }

  handlePost() async {
    setState(() {
      _isUploading = true;
    });
    compressImage();
    String mediaUrl = await uploadPhoto(_image);
    setState(() {
      urll = mediaUrl;
    });
    _isUploading = false;
  }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create New Post"),
            children: [
              SimpleDialogOption(
                child: Text("Image From Gallery"),
                onPressed: () => handleChooseImage(),
              ),
              SimpleDialogOption(
                child: Text("Take a Picture"),
                onPressed: () => handleTakePhoto(),
              ),
              SimpleDialogOption(
                child: Text("Cancle"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.deepOrange,
              child: Text(
                "Upload Image",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => selectImage(context))
        ],
      ),
    );
  }

  clearFile() {
    setState(() {
      _image = null;
    });
  }

  buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: clearFile),
        title: Text(
          "Caption post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: _isUploading ? null : handlePost,
            child: Text(
              "Post",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.blueAccent),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _isUploading ? linearProgress() : Text(""),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(_image),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.currentUser.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: TextFormField(
                decoration: InputDecoration(
                    hintText: "write a caption", border: InputBorder.none),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.pin_drop),
            title: Container(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "where is this photo taken"),
              ),
            ),
          ),
          Container(
            width: 200,
            height: 100,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              onPressed: () => print("cureenet location"),
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              label: Text(
                "get current location",
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.blueAccent.withOpacity(0.6),
            ),
          ),
          Text(urll)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _image == null ? buildSplashScreen() : buildUploadForm();
  }
}
