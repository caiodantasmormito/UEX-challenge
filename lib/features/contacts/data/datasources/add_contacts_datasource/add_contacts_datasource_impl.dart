import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uex_app/features/contacts/data/datasources/add_contacts_datasource/add_contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

class AddContactsDatasourceImpl implements AddContactsDatasource {
  @override
  Future<void> addContacts({required ContactsModel contactsModel}) async {
    final collection = FirebaseFirestore.instance.collection("contacts");

    await collection.add(
      {
        "name": contactsModel.name,
        "cpf": contactsModel.cpf,
        "address": contactsModel.address,
        "latitude": contactsModel.latitude,
        "longitude": contactsModel.longitude,
        "cep": contactsModel.cep
      },
    );
  }
}
