import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

part 'master_event.dart';
part 'master_state.dart';

class MasterBloc extends Bloc<MasterEvent, MasterState> {
  List<dynamic> _notesList = [];
  List<dynamic> get getNotesList => _notesList;
  TextEditingController _notesController = TextEditingController();
  TextEditingController get getNotesController => _notesController;
  File? _chosenImage;

  MasterBloc() : super(MasterInitial()) {
    on<GetStoredNotesEvent>(_onGetStoredNotesEvent);
    on<SaveNoteToStorageEvent>(_onSaveNoteToStorageEvent);
    on<ClearNotesFormEvent>(_onClearNotesFormEvent);
    on<ChangeImageEvent>(_onChangeImageEvent);
  }
  // Event handlers
  FutureOr<void> _onGetStoredNotesEvent(
    GetStoredNotesEvent event,
    Emitter emit,
  ) async {
    try {
      emit(RetrievedNotesProcessingState());
      var _notesBox = await Hive.openBox<dynamic>("notes");
      _notesList = _notesBox.values.first;
      // _notesList = _notesBox.get("allMyNotes") ?? [];
      emit(RetrievedNotesState(notesList: _notesList));
    } catch (e) {
      emit(
        RetrievedNotesErrorState(
          errorMsg: "No se encontraron notas guardadas...",
        ),
      );
    }
  }

  FutureOr<void> _onSaveNoteToStorageEvent(
    SaveNoteToStorageEvent event,
    Emitter emit,
  ) async {
    try {
      emit(RetrievedNotesProcessingState());
      var _notesBox = await Hive.openBox<dynamic>("notes");
      _notesList.add(
        {
          "path": "${_chosenImage!.path}",
          "note": "${_notesController.text}",
        },
      );
      await _notesBox.put("allMyNotes", _notesList);
      emit(FormSavedState());
    } catch (e) {
      emit(
        FormSavedErrorState(
            errorMsg: "Error al guardar las notas en storage..."),
      );
    }
  }

  FutureOr<void> _onClearNotesFormEvent(
    ClearNotesFormEvent event,
    Emitter emit,
  ) {
    emit(FormProcessingState());
    _notesController.clear();
    _chosenImage = null;
    emit(FormClearedState());
  }

  FutureOr<void> _onChangeImageEvent(
    ChangeImageEvent event,
    Emitter emit,
  ) async {
    emit(FormProcessingState());
    await _getImage();
    if (_chosenImage != null)
      emit(ImageChangedState(newImage: _chosenImage!));
    else
      emit(ImageChangedErrorState(errorMsg: "No se eligio imagen"));
  }

  // Other methods
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      _chosenImage = File(pickedFile.path);
    } else {
      print('No image selected.');
      _chosenImage = null;
    }
  }
}
