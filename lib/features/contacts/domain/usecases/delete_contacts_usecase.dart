import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/domain/repositories/contacts_repository.dart';

class DeleteContactsUsecase implements UseCase<NoParams, String> {
  final ContactsRepository _contactsRepository;

  DeleteContactsUsecase({required ContactsRepository contactsRepository})
      : _contactsRepository = contactsRepository;

  @override
  Future<(Failure?, NoParams?)> call(String contactId) =>
      _contactsRepository.deleteContact(contactId);
}
