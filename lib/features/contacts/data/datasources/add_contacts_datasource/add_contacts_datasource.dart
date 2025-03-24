import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

abstract interface class AddContactsDatasource {
  Future<void> addContacts({
    required ContactsModel contactsModel
  });
}
