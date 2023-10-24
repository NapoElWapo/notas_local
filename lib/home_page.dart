import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_share/bloc/master_bloc.dart';
import 'package:notas_share/note_form_page.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, state) {
          if (state is RetrievedNotesErrorState) {
            print("HomeError: ${state.errorMsg}");
          }
        },
        builder: (context, state) {
          return _showContent(
            BlocProvider.of<MasterBloc>(context).getNotesList,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NoteFormPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _showContent(List<dynamic> notesList) {
    return ListView.builder(
      itemCount: notesList.length,
      itemBuilder: (BuildContext context, int index) {
        var note = notesList[index];
        if (note["path"] != null) {
          String imagePath = note["path"];
          return ListTile(
            leading: CircleAvatar(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                await Share.shareXFiles(
                  [XFile(imagePath)],
                  text: note["note"],
                  subject: "Nota compartida desde notas_local",
                );
                await Share.share(
                  note["note"],
                  subject: "Nota compartida desde notas_local",
                );
              },
            ),
            title: Text(note["note"]),
          );
        }
        return ListTile(
          title: Text(note["note"]),
        );
      },
    );
  }
}