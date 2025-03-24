import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/repositories/get_contacts_repository.dart';

class GetContactsUsecase implements UseCase<List<ContactsEntity>, NoParams> {
  final GetContactsRepository _getContactsRepository;
  GetContactsUsecase({required GetContactsRepository getContactsRepository})
      : _getContactsRepository = getContactsRepository;

  @override
  Future<(Failure?, List<ContactsEntity>?)> call(NoParams params) =>
      _getContactsRepository.getContacts();
      
}
