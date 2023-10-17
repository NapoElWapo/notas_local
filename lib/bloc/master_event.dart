part of 'master_bloc.dart';

sealed class MasterEvent extends Equatable {
  const MasterEvent();

  @override
  List<Object> get props => [];
}

class GetStoredNotesEvent extends MasterEvent {}

class SaveNoteToStorageEvent extends MasterEvent {}

class ClearNotesFormEvent extends MasterEvent {}

class ChangeImageEvent extends MasterEvent {}
