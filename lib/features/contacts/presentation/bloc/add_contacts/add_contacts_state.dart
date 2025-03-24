part of 'add_contacts_bloc.dart';

sealed class AddContactsState extends Equatable {
  const AddContactsState();

  @override
  List<Object?> get props => [];
}

class AddContactsInitial extends AddContactsState {}

final class AddContactsLoading extends AddContactsState {}

final class AddContactsError extends AddContactsState {
  final String? message;

  const AddContactsError({required this.message});
}

final class AddContactsSuccess extends AddContactsState {}
