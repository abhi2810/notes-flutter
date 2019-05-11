import 'package:flutter/material.dart';
import 'package:notes/home/home.dart';
import 'package:notes/login/login.dart';
import 'package:notes/service/noteservice.dart';
import 'package:notes/service/userservice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final NoteService _noteService = new NoteService();
  final UserService _userService = new UserService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amberAccent,
      ),
      //home: HomePage(),
      routes: {
        "/": (BuildContext context) => LoginPage(_userService, _noteService),
        "home": (BuildContext context) => HomePage(_noteService, _userService),
      },
      onGenerateRoute: (RouteSettings settings) {
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(_noteService,_userService));
      },
    );
  }
}
