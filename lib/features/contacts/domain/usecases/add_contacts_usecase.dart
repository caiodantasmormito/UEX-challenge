import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/repositories/add_contacts_repository.dart';

class   AddContactsUsecase implements UseCase<NoParams, ContactsEntity> {
  final AddContactsRepository _repository;

  const AddContactsUsecase({
    required AddContactsRepository repository,
  }) : _repository = repository;

  @override
  Future<(Failure?, NoParams?)> call(ContactsEntity params) =>
      _repository.addContacts(contactsEntity: params);
}
