import 'package:flutter/material.dart';
import 'package:notes/home/home.dart';
import 'package:notes/service/auth.dart';
import 'package:notes/service/noteservice.dart';
import 'package:notes/service/userservice.dart';

class UserProfile extends StatefulWidget {
  final UserService _service;
  final NoteService _notesService;

  UserProfile(this._service, this._notesService);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  initState() {
    super.initState();

    // Subscriptions are created here
    authService.profile.listen((state) {
      setState(() {
        _profile = state;
        if (!_loading && _profile["email"] != null) {
          print(_profile);
          widget._service.user = _profile;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomePage(widget._notesService, widget._service);
          }));
        }
      });
    });

    authService.loading.listen((state) {
      setState(() {
        _loading = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
