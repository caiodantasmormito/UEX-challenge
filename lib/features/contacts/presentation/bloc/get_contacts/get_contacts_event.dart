part of 'get_contacts_bloc.dart';

sealed class GetContactsEvent extends Equatable {
  const GetContactsEvent();
}

final class GetDataContacts extends GetContactsEvent {
  const GetDataContacts();

  @override
  List<Object?> get props => [];
}
