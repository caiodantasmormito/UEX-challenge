part of 'add_contacts_bloc.dart';



sealed class AddContactsEvent extends Equatable {
  const AddContactsEvent();
}

final class CreateContacts extends AddContactsEvent {

  const CreateContacts(this.params);
  final ContactsEntity params;
  @override
  List<Object> get props => [params];

 
  }

