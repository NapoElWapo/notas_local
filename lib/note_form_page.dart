import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/master_bloc.dart';

class NoteFormPage extends StatelessWidget {
  NoteFormPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create your notes'),
      ),
      body: BlocConsumer<MasterBloc, MasterState>(
        listener: (context, state) {
          if (state is FormSavedState) {
            Navigator.of(context).pop();
            _warningFormStateSnackbar(
              "Nota guardada en almacenamiento.",
              context,
              false,
            );
          } else if (state is FormProcessingState) {
            _warningFormStateSnackbar(
              "Procesando ...",
              context,
              false,
            );
          } else if (state is FormSavedErrorState) {
            _warningFormStateSnackbar(
              "Error: ${state.errorMsg}...",
              context,
              true,
            );
          } else if (state is ImageChangedErrorState) {
            _warningFormStateSnackbar(
              "Error: ${state.errorMsg}...",
              context,
              true,
            );
          }
        },
        builder: (context, state) {
          if (state is ImageChangedState) {
            return _defaultFormState(state.newImage, context);
          } else if (state is FormProcessingState) {
            return _processingFormState();
          } else {
            return _defaultFormState(null, context);
          }
        },
      ),
    );
  }

  _defaultFormState(File? newSelectedImage, BuildContext? blocContext) {
    return ListView(
      children: [
        _selectedImage(newSelectedImage),
        TextField(
          controller:
              BlocProvider.of<MasterBloc>(blocContext!).getNotesController,
          maxLines: 4,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: "Agregar nota"),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<MasterBloc>(blocContext)
                .add(SaveNoteToStorageEvent());
          },
          child: Text("Guardar nota"),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<MasterBloc>(blocContext).add(ChangeImageEvent());
          },
          child: Text("Tomar foto"),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<MasterBloc>(blocContext).add(ClearNotesFormEvent());
          },
          child: Text("Limpiar formulario"),
        ),
      ],
    );
  }

  Widget _processingFormState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Processing data..."),
          SizedBox(height: 64),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _selectedImage(File? newSelectedImage) => newSelectedImage == null
      ? Container()
      : Image.file(
          newSelectedImage,
          height: 200,
          fit: BoxFit.fill,
        );
  void _warningFormStateSnackbar(
    String message,
    BuildContext context,
    bool isErrorSnackbar,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isErrorSnackbar ? Colors.red : Colors.green,
          content: Text(
            "$message",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
  }
}