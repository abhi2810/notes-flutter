import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/model/notesmodel.dart';
import 'package:notes/service/auth.dart';
import 'package:notes/service/noteservice.dart';
import 'package:notes/service/userservice.dart';

class HomePage extends StatefulWidget {
  HomePage(this.service, this.userService);

  final NoteService service;
  final UserService userService;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> color = [
    Colors.white,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.cyan,
    Colors.limeAccent,
  ];
  final Map<String, dynamic> element = {
    "title": "",
    "content": "",
    "color": 0,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _editNotes(NotesModel note, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(note == null ? "Add Note" : "Edit Note"),
          content: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) return "Title can't be empty.";
                  },
                  initialValue: note == null ? "" : note.title,
                  decoration: InputDecoration(labelText: "title"),
                  onSaved: (String value) {
                    element["title"] = value;
                  },
                ),
                TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) return "Content can't be empty.";
                  },
                  initialValue: note == null ? "" : note.content,
                  decoration: InputDecoration(labelText: "Content"),
                  maxLines: 4,
                  onSaved: (String value) {
                    element["content"] = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            element["color"] = 1;
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            radius: 15.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            element["color"] = 2;
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            radius: 15.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            element["color"] = 3;
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.cyan,
                            radius: 15.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            element["color"] = 4;
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.limeAccent,
                            radius: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Discard"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                if (note == null) {
                  setState(() {
                    widget.service.addNote(
                      NotesModel(
                        title: element["title"],
                        color: element["color"],
                        content: element["content"],
                      ),
                    );
                    element["color"] = 0;
                  });
                } else {
                  setState(() {
                    widget.service.updateNote(
                        NotesModel(
                          title: element["title"],
                          color: element["color"],
                          content: element["content"],
                        ),
                        index);
                    element["color"] = 0;
                  });
                }
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userService.user);
    final List<NotesModel> notes = widget.service.notes;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: CircleAvatar(
                backgroundImage: widget.userService.user["photoURL"] == null
                    ? AssetImage('assets/userplaceholder.png')
                    : NetworkImage(widget.userService.user["photoURL"]),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: notes.length == 0
              ? Center(
                  child: Text("click on + button to add notes."),
                )
              : StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: color[notes[index].color],
                          boxShadow: [
                            BoxShadow(),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _editNotes(notes[index], index);
                              print("tapped");
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete?"),
                                    content: Text("This can't be undone"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          setState(() {
                                            widget.service.deleteNote(index);
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      notes[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 5.0),
                                  ),
                                  Container(
                                    child: Text(
                                      notes[index].content,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  staggeredTileBuilder: (int index) => StaggeredTile.count(
                      2,
                      1 +
                          (notes[index].content.length / 100) +
                          (notes[index].title.length / 100)),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editNotes(null, 0),
        tooltip: 'Add Notes',
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
