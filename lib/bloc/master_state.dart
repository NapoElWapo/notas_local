part of 'master_bloc.dart';

sealed class MasterState extends Equatable {
  const MasterState();

  @override
  List<Object> get props => [];
}

final class MasterInitial extends MasterState {}

// Image change states
final class ImageChangedState extends MasterState {
  final File newImage;

  ImageChangedState({required this.newImage});
  @override
  List<Object> get props => [newImage];
}

final class ImageChangedErrorState extends MasterState {
  final String errorMsg;

  ImageChangedErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

// Form states
final class FormClearedState extends MasterState {}

final class FormProcessingState extends MasterState {}

final class FormSavedState extends MasterState {}

final class FormSavedErrorState extends MasterState {
  final String errorMsg;

  FormSavedErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

// Home states
final class RetrievedNotesState extends MasterState {
  final List<dynamic> notesList;

  RetrievedNotesState({required this.notesList});
  @override
  List<Object> get props => [notesList];
}

final class RetrievedNotesProcessingState extends MasterState {}

final class RetrievedNotesErrorState extends MasterState {
  final String errorMsg;

  RetrievedNotesErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
