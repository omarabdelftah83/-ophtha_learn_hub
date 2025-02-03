import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinar/common/utils/app_text.dart';

import '../../../../../config/colors.dart';




class NotesPage extends StatefulWidget {
  static const String pageName = '/notes-page';
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keep It'),
        centerTitle: true,
        backgroundColor: mainColor(),
        // bottom: TabBar(
        //   controller: _tabController,
        //   indicatorColor: Colors.white,
        //   tabs: [
        //     // Tab(icon: Icon(Icons.note_alt, color: Colors.white), text: 'Keep It'),
        //     // Tab(icon: Icon(Icons.monetization_on, color: Colors.white), text: 'Manage Profits'),
        //   ],
        // ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          KeepItPage(),
        ],
      ),
    );
  }
}

class KeepItPage extends StatefulWidget {
  @override
  _KeepItPageState createState() => _KeepItPageState();
}

class _KeepItPageState extends State<KeepItPage> {
  List<String> sections = [];
  Map<String, List<Map<String, String>>> notes = {};
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController noteTitleController = TextEditingController();
  final TextEditingController noteContentController = TextEditingController();
  String? selectedSection;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sections = prefs.getStringList('sections') ?? [];
      String? notesJson = prefs.getString('notes');
      if (notesJson != null) {
        notes = Map<String, List<Map<String, String>>>.from(
          json.decode(notesJson).map((key, value) => MapEntry(
            key,
            List<Map<String, String>>.from(value.map((item) => Map<String, String>.from(item))),
          )),
        );
      }
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('sections', sections);
    await prefs.setString('notes', json.encode(notes));
  }



  void _deleteSection(String section) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Section'),
          content: Text('Are you sure you want to delete the section "$section" and all its notes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  sections.remove(section); // حذف القسم
                  notes.remove(section); // حذف الملاحظات المرتبطة به
                  _saveData(); // حفظ البيانات بعد الحذف
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: sections.length + 1,
      child: Scaffold(
        appBar: TabBar(
          isScrollable: true,
          indicatorColor: mainColor(),
          tabs: [
            Tab(
              icon: Icon(Icons.add, color: mainColor()),
              child: Text(
                "Inputs",
                style: TextStyle(color: keepItTextColor()),
              ),
            ),
            ...sections.map((section) => Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder, color: mainColor()), // أيقونة القسم
                  SizedBox(width: 5),
                  Text(
                    section,
                    style: TextStyle(color: textIconsNav()),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => _deleteSection(section),
                    child: Icon(Icons.close, color: Colors.red, size: 18), // زر الحذف
                  ),
                ],
              ),
            )),
          ],
        ),
        body: TabBarView(
          children: [
            _buildInputTab(),
            ...sections.map((section) => Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: _buildNotesTab(section),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: sectionController,
            decoration: InputDecoration(
              labelText: 'New Section',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.folder, color: mainColor()),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (sectionController.text.isNotEmpty) {
                setState(() {
                  sections.add(sectionController.text);
                  notes[sectionController.text] = [];
                  sectionController.clear();
                  _saveData();
                });
              }
            },
            child: Text('Add Section'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: noteTitleController,
            decoration: InputDecoration(
              labelText: 'Note Title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title, color: mainColor()),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: noteContentController,
            decoration: InputDecoration(
              labelText: 'Note Content',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.notes, color: mainColor()),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedSection,
            hint: Text("Select Section"),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.list, color: mainColor()),
            ),
            items: sections.map((section) {
              return DropdownMenuItem(value: section, child: Text(section));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSection = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              final title = noteTitleController.text;
              final content = noteContentController.text;
              if (title.isNotEmpty && content.isNotEmpty && selectedSection != null) {
                setState(() {
                  notes[selectedSection!]?.add({'title': title, 'content': content});
                  noteTitleController.clear();
                  noteContentController.clear();
                  _saveData();
                });
              }
            },
            child: Text('Add Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(String section) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: notes[section]?.map((note) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(note['title'] ?? ''),
            subtitle: Text(note['content']?.split('\n').first ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.blue),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text:
                        "${note['title']}\n\n${note['content']}")); // نسخ العنوان والمحتوى
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: mainColor(),
                      content: Text(appText.copiedToClipboard),
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: mainColor()),
                  onPressed: () {
                    _editNoteDialog(section, note);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      notes[section]?.remove(note);
                      _saveData();
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(note['title'] ?? ''),
                    content: Text(note['content'] ?? ''),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      }).toList() ?? [],
    );
  }

  void _editNoteDialog(String section, Map<String, String> note) {
    noteTitleController.text = note['title'] ?? '';
    noteContentController.text = note['content'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteTitleController,
                decoration: InputDecoration(
                  labelText: 'Note Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: noteContentController,
                decoration: InputDecoration(
                  labelText: 'Note Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  note['title'] = noteTitleController.text;
                  note['content'] = noteContentController.text;
                  _saveData();
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}








