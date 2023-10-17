import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notas_share/bloc/master_bloc.dart';
import 'package:notas_share/note_form_page.dart';

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
        return ListTile(
          // leading: CircleAvatar(
          //   child: Image.asset(
          //     "${notesList[index]["path"]}",
          //     fit: BoxFit.contain,
          //   ),
          // ),
          title: Text("${notesList[index]["note"]}"),
        );
      },
    );
  }
}
