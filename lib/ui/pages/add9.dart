//
//
//
//import 'dart:io';
//
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:iremember/models/user.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:uuid/uuid.dart';
//import 'home9.dart';
//import 'package:image/image.dart' as Im;
//
////TODO allow user to pick image and display the preview in UI
////TODO save new data to firestore (upload image to storage)
//class AddPage extends StatefulWidget {
//  final User currentUser;
//  AddPage({this.currentUser});
//
//  @override
//  _AddPageState createState() => _AddPageState();
//}
//
//class _AddPageState extends State<AddPage> {
//  String title;
//  String description;
//  TextEditingController titleController = TextEditingController();
//  TextEditingController descriptionController = TextEditingController();
//  File file;
//  bool isUploading = false;
//  String postId = Uuid().v4();
//
//  handleCamera() async {
//    Navigator.pop(context);
//    File file = await ImagePicker.pickImage(
//        source: ImageSource.camera, maxHeight: 650.0, maxWidth: 950.0);
//    setState(() {
//      this.file = file;
//    });
//  }
//
//  handleGallary() async {
//    Navigator.pop(context);
//    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      this.file = file;
//    });
//  }
//
//  clearImage() {
//    setState(() {
//      file = null;
//    });
//  }
//
//  compressImage() async {
//    final tempDir = await getTemporaryDirectory();
//    final path = await tempDir.path;
//    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
//    final compressImageFile = File('$path/img_$postId.jpg')
//      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
//    setState(() {
//      file = compressImageFile;
//    });
//  }
//
//  uploadImage(imageFile) async {
//    StorageUploadTask storageUploadTask =
//    await storageReference.child('post_$postId.jpg').putFile(imageFile);
//    StorageTaskSnapshot storageTaskSnapshot =
//    await storageUploadTask.onComplete;
//    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
//    return downloadurl;
//  }
//
//  createPostInFireStore(
//      {String mediaUrl, String location, String description}) {
//    postsRef
//        .document(widget.currentUser.id)
//        .collection('usersPosts')
//        .document(postId)
//        .setData({
//      'ownerId': widget.currentUser.id,
//      'username': widget.currentUser.username,
//      'postId': postId,
//      'mediaUrl': mediaUrl,
//      'location': location,
//      'description': description,
//      'timestamp': timestamp,
//      'likes': {}
//    });
//  }
//
//  handleSubmit() async {
//    setState(() {
//      isUploading = true;
//    });
//
//    await compressImage();
//    String mediaUrl = await uploadImage(file);
//    createPostInFireStore(
//      mediaUrl: mediaUrl,
//      location: titleController.text,
//      description: descriptionController.text,
//    );
//    titleController.clear();
//    descriptionController.clear();
//    setState(() {
//      file = null;
//      isUploading = false;
//    });
//  }
//
//  Scaffold buildPostScreen() {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: clearImage,
//          color: Colors.black,
//        ),
//        title: Text(
//          'Caption For Post',
//          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//        ),
//        actions: <Widget>[
//          FlatButton(
//              onPressed: isUploading ? null : () => handleSubmit(),
//              child: Text(
//                'Post',
//                style: TextStyle(
//                    color: Colors.blueAccent,
//                    fontWeight: FontWeight.bold,
//                    fontSize: 20),
//              ))
//        ],
//      ),
//      body: ListView(
//        children: <Widget>[
//          isUploading ? linearProgress() : Text(''),
//          Container(
//            height: 220,
//            width: MediaQuery
//                .of(context)
//                .size
//                .width * 0.9,
//            child: AspectRatio(
//              aspectRatio: 16 / 9,
//              child: Container(
//                decoration: BoxDecoration(
//                    image: DecorationImage(
//                        image: FileImage(file), fit: BoxFit.cover)),
//              ),
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.only(top: 10),
//          ),
//          ListTile(
//            leading: CircleAvatar(
//              backgroundImage:
//              CachedNetworkImageProvider(widget.currentUser.photoUrl),
//            ),
//            title: Container(
//              child: TextField(
//                controller: captionController,
//                decoration: InputDecoration(
//                  hintText: 'Write Caption For Image',
//                  border: InputBorder.none,
//                ),
//              ),
//            ),
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(
//              Icons.pin_drop,
//              color: Colors.orange,
//              size: 40.0,
//            ),
//            title: Container(
//              child: TextField(
//                controller: locationController,
//                decoration: InputDecoration(
//                  hintText: 'Add Location For Image',
//                  border: InputBorder.none,
//                ),
//              ),
//            ),
//          ),
//          Divider(),
//          Container(
//            height: 100.0,
//            width: 200,
//            alignment: Alignment.center,
//            child: RaisedButton.icon(
//              onPressed: getCurrentUserLocation,
//              icon: Icon(
//                Icons.my_location,
//              ),
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(40)),
//              label: Text(
//                'Add Current Location',
//                style:
//                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//              ),
//              color: Colors.blueAccent,
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  getCurrentUserLocation() async {
//    Position position = await Geolocator().getCurrentPosition(
//        desiredAccuracy: LocationAccuracy.best);
//    List<Placemark> marks = await Geolocator().placemarkFromCoordinates(
//        position.latitude, position.longitude);
//    Placemark placemark = marks[0];
//    String completeAddress = '${placemark.country},${placemark.subLocality}';
//    locationController.text = completeAddress;
//  }
//
//  selectImage(parentContext) {
//    return showDialog(
//        context: parentContext,
//        builder: (context) {
//          return SimpleDialog(
//            title: Text('Create Post'),
//            children: <Widget>[
//              SimpleDialogOption(
//                child: Text('Image With Camera'),
//                onPressed: handleCamera,
//              ),
//              SimpleDialogOption(
//                child: Text('Image With Gallary'),
//                onPressed: handleGallary,
//              ),
//              SimpleDialogOption(
//                child: Text('Cancel'),
//                onPressed: () => Navigator.pop(context),
//              ),
//            ],
//          );
//        });
//  }
//
//  Container buildForm() {
//    return Container(
//      color: Theme
//          .of(context)
//          .accentColor,
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          SvgPicture.asset(
//            'assets/images/upload.svg',
//            height: 300,
//          ),
//          Padding(
//            padding: EdgeInsets.only(
//              top: 20.0,
//            ),
//            child: RaisedButton(
//              onPressed: () => selectImage(context),
//              child: Text(
//                'Upload Image',
//                style:
//                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//              ),
//              color: Colors.deepOrange,
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(15.0),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return file == null ? buildForm() : buildPostScreen();
//  }
//}
//
////  @override
////  Widget build(BuildContext context) {
////
////    return Scaffold(
////      appBar: AppBar(
////        title: Text("Add item"),
////        backgroundColor: Colors.blueAccent,
////      ),
////      body: ListView(
////        padding: EdgeInsets.all(10),
////        children: <Widget>[
////          SizedBox(
////            height: 30.0,
////          ),
////          _buildTitleField(),
////          SizedBox(
////            height: 20,
////          ),
////          _buildDescriptionField(),
////          SizedBox(
////            height: 20,
////          ),
////          _buildImgSelectButton(),
////          SizedBox(
////            height: 20,
////          ),
////          _buildSaveButton(context)
////        ],
////      ),
////    );
////  }
//
////  TextField _buildTitleField() {
////    return TextField(
////      onChanged: (value) {
////        setState(() {
////          title = value;
////        });
////      },
////      decoration: InputDecoration(
////          border: OutlineInputBorder(),
////          hintText: "title",
////          prefixIcon: Icon(Icons.title)),
////    );
////  }
////
////  TextField _buildDescriptionField() {
////    return TextField(
////      onChanged: (value) {
////        setState(() {
////          description = value;
////        });
////      },
////      maxLines: 4,
////      decoration: InputDecoration(
////        border: OutlineInputBorder(),
////        hintText: "Description",
////      ),
////    );
////  }
////
////  SizedBox _buildImgSelectButton() {
////    return SizedBox(
////      height: 50,
////      width: double.infinity,
////      child: RaisedButton.icon(
////        icon: Icon(Icons.camera),
////        label: Text("Add Image"),
////        color: Colors.blue,
////        onPressed: ()=>_showDialog(context),
////      ),
////    );
////  }
////
////  SizedBox _buildSaveButton(BuildContext context) {
////    return SizedBox(
////      height: 50,
////      width: 20.0,
////      child: RaisedButton.icon(
////        icon: Icon(Icons.save),
////        label: Text("Save"),
////        color: Colors.blue,
////        onPressed: () async {},
////      ),
////    );
////  }
//}
//
////void _showDialog(context) {
////  // flutter defined function
////  showDialog(
////    context: context,
////    builder: (BuildContext context) {
////      // return object of type Dialog
////      return AlertDialog(
////        title: new Text("Upload Image"),
////        content: Container(
////          height: MediaQuery.of(context).size.height*.35,
////          child: Column(
////            children: <Widget>[
////              Container(
////                height: 50.0,
////                width: MediaQuery.of(context).size.width*.9,
////                child: RaisedButton.icon(
////                  icon: Icon(Icons.photo_camera),
////                  label: Text("Upload Image by Camera"),
////                  color: Colors.blue,
////                  onPressed: ()=>_showDialog(context),
////                ),
////              ),
////              SizedBox(height: 20.0,),
////              Container(
////                height: 50.0,
////                width: MediaQuery.of(context).size.width*.9,
////                child: RaisedButton.icon(
////                  icon: Icon(Icons.file_upload),
////                  label: Text("Upload Image From Gallery"),
////                  color: Colors.blue,
////                  onPressed: (){},
////                ),
////              ),
////            ],
////          ),
////        ),
////        actions: <Widget>[
////          // usually buttons at the bottom of the dialog
////          new FlatButton(
////            child: new Text("Close"),
////            onPressed: () {
////              Navigator.of(context).pop();
////            },
////          ),
////        ],
////      );
////    },
////  );
////}
//
