import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

abstract interface class ContactsDatasource {
  Future<void> addContacts({
    required ContactsModel contactsModel
  });
  Future<List<ContactsModel>> getContacts(String userId);
  Future<void> deleteContact(String contactId);
}
