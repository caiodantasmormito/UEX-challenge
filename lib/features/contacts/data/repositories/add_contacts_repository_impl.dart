// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/data/datasources/add_contacts_datasource/add_contacts_datasource.dart';
import 'package:uex_app/features/contacts/domain/failures/failures.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/data/exceptions/exception.dart';
import 'package:uex_app/features/contacts/domain/repositories/add_contacts_repository.dart';

class AddContactsRepositoryImpl implements AddContactsRepository {
  final AddContactsDatasource _addContactsDataSource;

  AddContactsRepositoryImpl(
      {required AddContactsDatasource addContactsDataSource})
      : _addContactsDataSource = addContactsDataSource;


  @override
  Future<(Failure?, NoParams?)> addContacts(
      {required ContactsEntity contactsEntity}) async {
    try {
      await _addContactsDataSource.addContacts(
          contactsModel: contactsEntity.toModel());
      return (null, null);
    } on AddContactsException catch (error) {
      return (
        AddContactsFailure(message: error.message),
        null,
      );
    }
  }
}
