import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iremember/models/user.dart';
import 'package:iremember/utils/widgets/header.dart';
import 'package:iremember/utils/widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'home.dart';

//TODO allow user to pick image and display the preview in UI
//TODO save new data to firestore (upload image to storage)
class AddPage extends StatefulWidget {
  final User currentUser;

  AddPage({this.currentUser});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String title;
  String description;
  TextEditingController locationController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();

  handleCamera() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 650.0, maxWidth: 950.0);
    setState(() {
      this.file = file;
    });
  }

  handleGallary() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = await tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressImageFile;
    });
  }

  uploadImage(imageFile) async {
    StorageUploadTask storageUploadTask =
        await storageReference.child('post_$postId.jpg').putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  createPostInFireStore(
      {String mediaUrl,
      String location,
      String description,
      String title,
      String caption}) {
    postsRef
        .document(widget.currentUser.id)
        .collection('usersPosts')
        .document(postId)
        .setData({
      'ownerId': widget.currentUser.id,
      'username': widget.currentUser.username,
      'postId': postId,
      'mediaUrl': mediaUrl,
      'title': title,
      'location': location,
      'description': description,
      'caption': caption,
      'timestamp': timestamp,
      'likes': {}
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });

    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFireStore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      title: titleController.text,
      description: descriptionController.text,
    );
    locationController.clear();
    titleController.clear();
    descriptionController.clear();
    setState(() {
      file = null;
      isUploading = false;
    });
  }

  TextField _buildTitleField() {
    return TextField(
      controller: titleController,
      onChanged: (value) {
        setState(() {
          title = value;
        });
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "title",
          prefixIcon: Icon(Icons.title)),
    );
  }

  TextField _buildDescriptionField() {
    return TextField(
      controller: descriptionController,
      onChanged: (value) {
        setState(() {
          description = value;
        });
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Description",
      ),
    );
  }


  ListTile _showLocField() {
    return ListTile(
      leading: Icon(
        Icons.pin_drop,
        color: Colors.orange,
        size: 40.0,
      ),
      title: Container(
        child: TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: 'Where was the photo taken?',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  SizedBox _buildLocSelectButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: RaisedButton.icon(
        icon: Icon(Icons.pin_drop),
        label: Text("Add Current Location"),
        color: Colors.blue,
        onPressed: getCurrentUserLocation,
      ),
    );
  }

  SizedBox _buildImgSelectButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: RaisedButton.icon(
        icon: Icon(Icons.camera),
        label: Text("Add Image"),
        color: Colors.blue,
        onPressed: () => selectImage(context),
      ),
    );
  }

  SizedBox _buildSaveButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 20.0,
      child: RaisedButton.icon(
        icon: Icon(Icons.save),
        label: Text("Save"),
        color: Colors.blue,
        onPressed: isUploading ? null : () => handleSubmit(),
      ),
    );
  }

  Scaffold buildPostScreen() {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          isUploading ? linearProgress() : Text(''),
          SizedBox(
            height: 30.0,
          ),
          _buildTitleField(),
          SizedBox(
            height: 20,
          ),
          _buildDescriptionField(),
          SizedBox(
            height: 20,
          ),
          _showLocField(),
          SizedBox(
            height: 20,
          ),
          _buildLocSelectButton(),
          SizedBox(
            height: 20,
          ),
          _buildImgSelectButton(),
          SizedBox(
            height: 20,
          ),
          _buildSaveButton(context)
        ],
      ),
    );
  }

  getCurrentUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> marks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = marks[0];
    String completeAddress = '${placemark.country},${placemark.subLocality}';
    locationController.text = completeAddress;
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return AlertDialog(
            title: new Text("Upload Image"),
            content: Container(
              height: MediaQuery.of(context).size.height * .35,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * .9,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.photo_camera),
                      label: Text("Upload Image by Camera"),
                      color: Colors.blue,
                      onPressed: handleCamera,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * .9,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.file_upload),
                      label: Text("Upload Image From Gallery"),
                      color: Colors.blue,
                      onPressed: handleGallary,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPostScreen(),
    );
  }
}
