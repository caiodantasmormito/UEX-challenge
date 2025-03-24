part of 'get_contacts_bloc.dart';

sealed class GetContactsState extends Equatable {
  const GetContactsState();

  @override
  List<Object?> get props => [];
}

class GetContactsInitial extends GetContactsState {}

final class GetContactsLoading extends GetContactsState {}

final class GetContactsError extends GetContactsState {
  final String? message;

  const GetContactsError({required this.message});
}

final class GetContactsSuccess extends GetContactsState {
   const GetContactsSuccess({required this.contacts});
  final List<ContactsEntity> contacts;
  @override
  List<Object> get props => [contacts];
}
