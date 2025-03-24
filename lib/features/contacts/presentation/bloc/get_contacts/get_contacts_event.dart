part of 'get_contacts_bloc.dart';

sealed class GetContactsEvent extends Equatable {
  const GetContactsEvent();
}

final class GetDataContacts extends GetContactsEvent {
  final String userId;
  const GetDataContacts({required this.userId});

  @override
  List<Object?> get props => [userId];
}

