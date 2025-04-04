import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uex_app/features/contacts/data/datasources/contacts_datasource/contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/exceptions/exception.dart';
import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

class ContactsDatasourceImpl implements ContactsDatasource {
  @override
  Future<List<ContactsModel>> getContacts(String userId) async {
    try {
      final collection = FirebaseFirestore.instance.collection("contacts");

      final querySnapshot =
          await collection.where('userId', isEqualTo: userId).get();

      final contacts = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ContactsModel.fromMap(data);
      }).toList();

      return contacts;
    } catch (e) {
      throw Exception("Falha ao buscar contatos: $e");
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    try {
      
      await FirebaseFirestore.instance
          .collection("contacts")
          .doc(contactId)
          .delete();
    } catch (e) {
      throw GetContactsException(message: "Erro ao excluir contato");
    }
  }

  @override
  Future<void> addContacts({required ContactsModel contactsModel}) async {
    final user = FirebaseAuth.instance.currentUser;
    final collection = FirebaseFirestore.instance.collection("contacts");
    final newDoc = collection.doc();

    await newDoc.set({
      "id": newDoc.id,
      "name": contactsModel.name,
      "cpf": contactsModel.cpf,
      "address": contactsModel.address,
      "cep": contactsModel.cep,
      "userId": user!.uid,
      "phone": contactsModel.phone,
      "city": contactsModel.city,
      "district": contactsModel.district,
      "uf": contactsModel.uf,
      "number": contactsModel.number,
    });
  }

  @override
  Future<bool> verifyCpfExists(String cpf) async {
    final query = await FirebaseFirestore.instance
        .collection('contacts')
        .where('cpf', isEqualTo: cpf)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  @override
  Future<void> updateContacts({required ContactsModel contactsModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc(contactsModel.id)
          .update(contactsModel.toMap());
    } catch (e) {
      throw UpdateContactsException(message: 'Erro ao atualizar contato');
    }
  }

  @override
  Future<ContactsModel> getContactById(String id) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('contacts').doc(id).get();
      if (doc.exists) {
        return ContactsModel.fromMap(doc.data()!..['id'] = doc.id);
      }
      throw Exception('Contato não encontrado');
    } catch (e) {
      throw Exception('Erro ao buscar contato');
    }
  }
}
