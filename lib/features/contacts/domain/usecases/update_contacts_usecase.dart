import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/failures/failures.dart';
import 'package:uex_app/features/contacts/domain/repositories/contacts_repository.dart';

class UpdateContactsUsecase implements UseCase<NoParams, ContactsEntity> {
  final ContactsRepository _repository;

  const UpdateContactsUsecase({
    required ContactsRepository repository,
  }) : _repository = repository;

  @override
  Future<(Failure?, NoParams?)> call(ContactsEntity params) async {
    
    final currentContact = await _repository.getContactById(params.id);
    
    
    if (currentContact.cpf != params.cpf) {
      
      final cpfExists = await _repository.verifyCpfExists(params.cpf);
      if (cpfExists) {
        return (UpdateContactsFailure(message: 'CPF já cadastrado'), null);
      }
    }

    
    return await _repository.updateContact(contact: params);
  }
}