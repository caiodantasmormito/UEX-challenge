part of 'delete_contacts_bloc.dart';

sealed class DeleteContactsState extends Equatable {
  const DeleteContactsState();

  @override
  List<Object?> get props => [];
}

class DeleteContactsInitial extends DeleteContactsState {}

final class DeleteContactsLoading extends DeleteContactsState {}

final class DeleteContactsError extends DeleteContactsState {
  final String? message;

  const DeleteContactsError({required this.message});
}

final class DeleteContactsSuccess extends DeleteContactsState {
   const DeleteContactsSuccess();
  
  @override
  List<Object> get props => [];
}
