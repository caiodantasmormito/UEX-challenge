import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

abstract class AddContactsRepository {
  Future<(Failure?, NoParams?)> addContacts(
      {required ContactsEntity contactsEntity});
}
