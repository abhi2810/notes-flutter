import 'package:notes/model/notesmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/service/auth.dart';

class NoteService {
  List<NotesModel> _notes = [];
  final Firestore _db = Firestore.instance;
  CollectionReference ref;

  NoteService() {
    ref = _db.collection('users').document(authService.uid).collection('notes');
    ref.getDocuments().then((query) {
      query.documents.forEach((snap) => _notes.add(new NotesModel(
          title: snap.data['title'],
          content: snap.data['content'],
          color: snap.data['color'])));
    });
  }

  List<NotesModel> get notes {
    return List.from(_notes);
  }

  void addNote(NotesModel note) {
    ref.add({
      "id": _notes.length,
      "title": note.title,
      "content": note.content,
      "color": note.color
    });
    _notes.add(note);
    print(note.title);
  }

  void deleteNote(int id) {
    _notes.removeAt(id);
  }

  void updateNote(NotesModel note, int id) {
    _notes[id] = note;
  }
}
