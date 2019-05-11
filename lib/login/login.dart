import 'package:flutter/material.dart';
import 'package:notes/service/noteservice.dart';
import 'package:notes/service/userservice.dart';
import 'package:notes/widget/loginbutton.dart';
import 'package:notes/widget/userprofile.dart';

class LoginPage extends StatelessWidget {
  final UserService userService;
  final NoteService noteService;

  LoginPage(this.userService,this.noteService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notes | Login'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[LoginButton(), UserProfile(userService,noteService)],
          ),
        ));
  }
}
