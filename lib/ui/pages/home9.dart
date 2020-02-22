////import 'package:cloud_firestore/cloud_firestore.dart';
////import 'package:firebase_storage/firebase_storage.dart';
////import 'package:flutter/material.dart';
////import 'package:iremember/models/user.dart';
////
//////TODO List out items from Firestore with image using the state management solution you have integrated
////class HomePage2 extends StatelessWidget {
////
////  @override
////  Widget build(BuildContext context) {
////    return Scaffold(
////      appBar: AppBar(
////        title: Text("Home"),
////        leading: Icon(Icons.home),
////        backgroundColor: Colors.blueAccent,
////      ),
////      body: Container()
////    );
////  }
////}
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:iremember/models/user.dart';
//import 'package:iremember/ui/pages/add2.dart';
//import 'package:iremember/ui/pages/create_account.dart';
//import 'AddPage3.dart';
//import 'AddPage4.dart';
//import 'AddPage5.dart';
//import 'AddPage6.dart';
//
//final GoogleSignIn googleSignIn = GoogleSignIn();
//final StorageReference storageReference = FirebaseStorage.instance.ref();
//final userRef = Firestore.instance.collection('users');
//final postsRef = Firestore.instance.collection('posts');
//final commentsRef = Firestore.instance.collection('comments');
//final activityFeedRef = Firestore.instance.collection('feed');
//final DateTime timestamp = DateTime.now();
//User currentUser;
//
//class Home2 extends StatefulWidget {
//  @override
//  _Home2State createState() => _Home2State();
//}
//
//class _Home2State extends State<Home2> {
//  bool isAuth = false;
//  PageController pageController;
//  int pageIndex = 0;
//
//  @override
//  void initState() {
//    super.initState();
//    pageController = PageController();
//    googleSignIn.onCurrentUserChanged.listen((account) {
//      handleSignIn(account);
//    }, onError: (err) {
//      print('Error User SignIn: $err');
//    });
//
//    googleSignIn.signInSilently(suppressErrors: false).then((account) {
//      handleSignIn(account);
//    }).catchError((err) {
//      print('Error User SignIn: $err');
//    });
//  }
//
//  handleSignIn(GoogleSignInAccount account) {
//    if (account != null) {
//      createUserFirestore();
//      setState(() {
//        isAuth = true;
//      });
//    } else {
//      setState(() {
//        isAuth = false;
//      });
//    }
//  }
//
//  createUserFirestore() async {
//    final GoogleSignInAccount user = googleSignIn.currentUser;
//    DocumentSnapshot doc = await userRef.document(user.id).get();
//
//    if (!doc.exists) {
//      final username = await Navigator.push(context,
//          MaterialPageRoute(builder: (context) => CreateAccount()));
//
//      userRef.document(user.id).setData({
//        'id': user.id,
//        'email': user.email,
//        'username': username,
//        'displayName': user.displayName,
//        'photoUrl': user.photoUrl,
//        'bio': '',
//        'timestamp': timestamp,
//      });
//      doc = await userRef.document(user.id).get();
//    }
//    currentUser = User.fromDocument(doc);
//    print(currentUser);
//    print(currentUser.username);
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    pageController.dispose();
//  }
//
//  onPageChanged(int pageIndex) {
//    setState(() {
//      this.pageIndex = pageIndex;
//    });
//  }
//
//  onTap(int pageIndex) {
//    pageController.animateToPage(
//      pageIndex,
//      duration: Duration(milliseconds: 200),
//      curve: Curves.easeInOutSine,
//    );
//  }
//
//  login() {
//    googleSignIn.signIn();
//  }
//
//  logout() {
//    googleSignIn.signOut();
//  }
//
//  Scaffold buildAuthScreen() {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Home"),
//        centerTitle: true,
//        leading: Icon(Icons.home),
//        backgroundColor: Colors.blueAccent,
//        actions: <Widget>[
//          RaisedButton.icon(onPressed: logout, icon: Icon(Icons.account_circle,color: Colors.white,), label: Text('Log Out',style: TextStyle(color: Colors.white),),color: Colors.blueAccent),
//        ],
//      ),
////        body: Center(child: RaisedButton(child: Text('Upload Data'), onPressed: (){
////          Navigator.push(context,
////              MaterialPageRoute(builder: (context) => AddPage2(currentUser:currentUser)));
////        })),
//      body: PageView(
//        children: <Widget>[
//          RaisedButton(child: Text('Log Out'), onPressed: logout),
////          ActivityFeed(),
//          AddPage2(currentUser:currentUser),
//          AddPage3(),
//          AddPage4(),
//          AddPage5(),
//          AddPage6(),
////          Search(),
////          Profile(profileId: currentUser?.id,),
//        ],
//        controller: pageController,
//        physics: NeverScrollableScrollPhysics(),
//        onPageChanged: onPageChanged,
//      ),
//      bottomNavigationBar: CupertinoTabBar(
//        currentIndex: pageIndex,
//        onTap: onTap,
//        activeColor: Theme.of(context).primaryColor,
//        items: [
//          BottomNavigationBarItem(
//            icon: Icon(Icons.whatshot),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.notifications_active),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.photo_camera),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.search),
//          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.account_circle),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Scaffold buildUnAuthScreen() {
//    return Scaffold(
//      body: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topRight,
//            end: Alignment.bottomRight,
//            colors: [
//              Theme.of(context).primaryColor.withOpacity(0.2),
//              Theme.of(context).accentColor,
//            ],
//          ),
//        ),
//        alignment: Alignment.center,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'IRemember',
//              style: GoogleFonts.vollkorn(
//                textStyle: TextStyle(fontSize: 40.0, color: Colors.white),
//              ),
//            ),
//            GestureDetector(
//              onTap: login,
//              child: Container(
//                height: 60,
//                width: 260,
//                decoration: BoxDecoration(
//                    image: DecorationImage(
//                  image: AssetImage('assets/images/google_signin_button.png'),
//                  fit: BoxFit.cover,
//                )),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
//  }
//}
