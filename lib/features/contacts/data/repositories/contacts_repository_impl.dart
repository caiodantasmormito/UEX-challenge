// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/data/datasources/contacts_datasource/contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/exceptions/exception.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/failures/failures.dart';
import 'package:uex_app/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsDatasource _contactsDataSource;

  ContactsRepositoryImpl({required ContactsDatasource contactsDataSource})
      : _contactsDataSource = contactsDataSource;

  @override
  Future<(Failure?, NoParams?)> addContacts(
      {required ContactsEntity contactsEntity}) async {
    try {
      await _contactsDataSource.addContacts(
          contactsModel: contactsEntity.toModel());
      return (null, null);
    } on AddContactsException catch (error) {
      return (
        AddContactsFailure(message: error.message),
        null,
      );
    }
  }

  @override
  Future<(Failure?, List<ContactsEntity>?)> getContacts(String userId) async {
    try {
      final result = await _contactsDataSource.getContacts(userId);
      return (null, result);
    } on GetContactsException catch (error) {
      return (
        GetContactsFailure(message: error.message),
        null,
      );
    }
  }

  @override
  Future<(Failure?, NoParams?)> deleteContact(String contactId) async {
    try {
      await _contactsDataSource.deleteContact(contactId);
      return (null, null);
    } on DeleteContactsException catch (error) {
      return (DeleteContactsFailure(message: error.message), null);
    }
  }

  @override
  Future<bool> verifyCpfExists(String cpf) async {
    try {
      return await _contactsDataSource.verifyCpfExists(cpf);
    } catch (e) {
      throw AddContactsException(message: 'Erro ao verificar CPF');
    }
  }

  @override
  Future<(Failure?, NoParams?)> updateContact(
      {required ContactsEntity contact}) async {
    try {
      await _contactsDataSource.updateContacts(
          contactsModel: contact.toModel());
      return (null, null);
    } on UpdateContactsException catch (error) {
      return (
        UpdateContactsFailure(message: error.message),
        null,
      );
    }
  }

  @override
  Future<ContactsEntity> getContactById(String id) async {
    try {
      final contactModel = await _contactsDataSource.getContactById(id);
      return contactModel.toModel();
    } catch (e) {
      throw Exception('Erro ao buscar contato por ID');
    }
  }
}
