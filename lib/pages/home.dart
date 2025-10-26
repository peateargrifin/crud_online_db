import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudonlinedb/services/firestore.dart';
import 'package:flutter/material.dart';

class homepg extends StatefulWidget {
  const homepg({super.key});

  @override
  State<homepg> createState() => _homepgState();
}

class _homepgState extends State<homepg> {
  final notecontrol = TextEditingController();
  final firestore fire = firestore();

  void dialog({String? id, QueryDocumentSnapshot? doc}) {
    if (doc != null) {
      notecontrol.text = doc['note'];
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: id == null ? Text("Add Note") : Text("Edit Note"),

        content: TextField(controller: notecontrol),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Check if we are adding or updating
              if (id == null) {
                // If id is null, we are adding a new note
                fire.addNote(notecontrol.text);
              } else {
                // Otherwise, we are updating an existing note
                fire.update(id, notecontrol.text);
              }

              // Clear the controller and close the dialog
              notecontrol.clear();
              Navigator.pop(context);
            },
            // Change button text dynamically
            child: Text(id == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("CRUD ONLINE DATABASE"), centerTitle: true),
        floatingActionButton: FloatingActionButton(
          onPressed: dialog,
          child: Icon(Icons.add_box),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: fire.getnote(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String id = snapshot.data!.docs[index].id;
                  final data = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(data['note']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end, /////,
                      children: [
                        IconButton(
                          onPressed: () => dialog(id: id, doc: data),
                          icon: Icon(Icons.edit),
                        ),
                        // SizedBox(width: 3),
                        IconButton(
                          onPressed: () => fire.delete(id),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text("no data"));
            }
          },
        ),
      ),
    );
  }
}
