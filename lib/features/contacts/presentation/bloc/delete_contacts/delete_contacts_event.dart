part of 'delete_contacts_bloc.dart';

sealed class DeleteContactsEvent extends Equatable {
  const DeleteContactsEvent();
}



class DeleteContact extends DeleteContactsEvent {
  final String contactId;
  

  const DeleteContact({required this.contactId});
  
  @override
  
  List<Object?> get props => [contactId,];
}