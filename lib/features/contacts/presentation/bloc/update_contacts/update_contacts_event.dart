part of 'update_contacts_bloc.dart';
abstract class UpdateContactsEvent extends Equatable {
  const UpdateContactsEvent();
}

class UpdateContact extends UpdateContactsEvent {
  final ContactsEntity contact;
  
  const UpdateContact(this.contact);

  @override
  List<Object> get props => [contact];
}