import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

abstract class GetContactsRepository {
  Future<(Failure?, List<ContactsEntity>?)> getContacts();
}
