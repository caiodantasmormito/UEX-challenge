import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uex_app/features/contacts/data/datasources/get_contacts_datasource/get_contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

class GetContactsDatasourceImpl implements GetContactsDatasource {
  @override
  Future<List<ContactsModel>> getContacts() async {
    final collection = FirebaseFirestore.instance.collection("contacts");

    final querySnapshot = await collection.get();

    final contacts = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ContactsModel.fromMap(data);
    }).toList();

    return contacts; 
  }
}
