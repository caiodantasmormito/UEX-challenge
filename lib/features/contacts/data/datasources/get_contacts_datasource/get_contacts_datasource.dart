import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

abstract interface class GetContactsDatasource {
  Future<List<ContactsModel>> getContacts();
}
