import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(context, {bool isAppTitle=false, String titleText, List<Widget> actions, Widget leading}) {
  return AppBar(
    title:Text(isAppTitle? 'IRemember': titleText,style: GoogleFonts.sourceSansPro(
      textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
    ),
    overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.blueAccent,
    actions: actions,
    leading: leading,
  );
}
