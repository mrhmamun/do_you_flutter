import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iremember/models/user.dart';
import 'package:iremember/utils/widgets/progress.dart';
import 'home.dart';

User currentUser;

class PostScreen extends StatefulWidget {
  final String postId;
  final String userId;
  PostScreen({this.postId, this.userId});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: postsRef
            .document(widget.userId)
            .collection('usersPosts')
            .snapshots(),
        builder: _getPost,
      ),
    );
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      _getPost;
    });
  }

  Widget _getPost(context, snapshots) {
    if (snapshots.connectionState == ConnectionState.waiting) {
      return Center(child: linearProgress());
    } else {
      return RefreshIndicator(
        onRefresh: getRefresh,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshots.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot post = snapshots.data.documents[index];
              return Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 350.0,
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      shadowColor: Color(0x802196F3),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(
                            8.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200.0,
                                child: Image.network(
                                  post['mediaUrl'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                post['title'],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                post['description'],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .47,
                        left: MediaQuery.of(context).size.height * .52),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: CircleAvatar(
                        backgroundColor: Color(0xff543B7A),
                        child: Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      );
    }
  }
}
