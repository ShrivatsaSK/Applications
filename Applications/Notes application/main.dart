import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(notes());

class notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      home: NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<Map<String, String>> _notes = [];
  final String _fileName = "notes.json";

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _loadNotes() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final data = await file.readAsString();
        final List<dynamic> jsonData = json.decode(data);

        setState(() {
          _notes = jsonData.map((note) {
            return {
              'id': note['id'] as String,
              'title': note['title'] as String,
              'content': note['content'] as String,
              'color': note['color'] as String,
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error loading notes: $e");
    }
  }

  Future<void> _saveNotes() async {
    try {
      final file = await _getLocalFile();
      await file.writeAsString(json.encode(_notes));
    } catch (e) {
      print("Error saving notes: $e");
    }
  }

  void _addNewNote() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddNoteModal(onAddNote: _saveNote);
      },
    );
  }

  void _saveNote(String title, String content, String color) {
    setState(() {
      _notes.add({
        'id': DateTime.now().toString(),
        'title': title,
        'content': content,
        'color': color,
      });
    });
    _saveNotes();
  }

  void _editNote(String id, String title, String content, String color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return AddNoteModal(
          onAddNote: (newTitle, newContent, newColor) {
            setState(() {
              final index = _notes.indexWhere((note) => note['id'] == id);
              _notes[index] = {
                'id': id,
                'title': newTitle,
                'content': newContent,
                'color': newColor,
              };
            });
            _saveNotes();
          },
          initialTitle: title,
          initialContent: content,
          initialColor: color,
        );
      },
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note['id'] == id);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: _notes.isEmpty
          ? Center(
              child: Text(
                'No notes yet! Tap + to add your first note.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                final note = _notes[index];
                return NoteCard(
                  id: note['id']!,
                  title: note['title']!,
                  content: note['content']!,
                  color: note['color']!,
                  onEdit: _editNote,
                  onDelete: _deleteNote,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddNoteModal extends StatefulWidget {
  final Function(String, String, String) onAddNote;
  final String? initialTitle;
  final String? initialContent;
  final String? initialColor;

  AddNoteModal({
    required this.onAddNote,
    this.initialTitle,
    this.initialContent,
    this.initialColor,
  });

  @override
  _AddNoteModalState createState() => _AddNoteModalState();
}

class _AddNoteModalState extends State<AddNoteModal> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController =
        TextEditingController(text: widget.initialContent ?? '');
    _selectedColor = widget.initialColor ?? '0xFFB2DFDB';
  }

  void _submitData() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      return;
    }

    widget.onAddNote(title, content, _selectedColor);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Text(
              'Pick a color:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                _buildColorCircle('0xFFB2DFDB'),
                _buildColorCircle('0xFFFFCDD2'),
                _buildColorCircle('0xFFFFF9C4'),
                _buildColorCircle('0xFFBBDEFB'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Save Note'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(String color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Color(int.parse(color)),
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final String color;
  final Function(String) onDelete;
  final Function(String, String, String, String) onEdit;

  NoteCard({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(int.parse(color)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => onEdit(id, title, content, color),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(id),
            ),
          ],
        ),
      ),
    );
  }
}
