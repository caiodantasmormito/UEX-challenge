import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/repositories/contacts_repository.dart';

class GetContactsUsecase implements UseCase<List<ContactsEntity>, String> {
  final ContactsRepository _getContactsRepository;
  GetContactsUsecase({required ContactsRepository getContactsRepository})
      : _getContactsRepository = getContactsRepository;

  @override
  Future<(Failure?, List<ContactsEntity>?)> call(String userId) =>
      _getContactsRepository.getContacts(userId);
}
