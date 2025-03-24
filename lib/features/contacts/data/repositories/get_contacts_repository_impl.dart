// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/features/contacts/data/datasources/get_contacts_datasource/get_contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/exceptions/exception.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/failures/failures.dart';
import 'package:uex_app/features/contacts/domain/repositories/get_contacts_repository.dart';

class GetContactsRepositoryImpl implements GetContactsRepository {
  final GetContactsDatasource _getContactsDataSource;

  GetContactsRepositoryImpl(
      {required GetContactsDatasource getContactsDataSource})
      : _getContactsDataSource = getContactsDataSource;

  @override
  Future<(Failure?, List<ContactsEntity>?)> getContacts() async {
    try {
      final result = await _getContactsDataSource.getContacts();
      return (null, result);
    } on GetContactsException catch (error) {
      return (
        GetContactsFailure(message: error.message),
        null,
      );
    }
  }
}
