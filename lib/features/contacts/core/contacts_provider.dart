import 'package:provider/provider.dart';
import 'package:uex_app/features/contacts/data/datasources/contacts_datasource/contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/datasources/contacts_datasource/contacts_datasource_impl.dart';
import 'package:uex_app/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:uex_app/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:uex_app/features/contacts/domain/usecases/add_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/delete_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/get_contacts_usecase.dart';

sealed class ContactsInject {
  static final List<Provider> providers = [
    Provider<ContactsDatasource>(
      create: (context) => ContactsDatasourceImpl(),
    ),
    Provider<ContactsRepository>(
      create: (context) => ContactsRepositoryImpl(
          contactsDataSource: context.read<ContactsDatasource>()),
    ),
    Provider<AddContactsUsecase>(
      create: (context) => AddContactsUsecase(
        repository: context.read<ContactsRepository>(),
      ),
    ),
    Provider<GetContactsUsecase>(
      create: (context) => GetContactsUsecase(
        getContactsRepository: context.read<ContactsRepository>(),
      ),
    ),
    Provider<DeleteContactsUsecase>(
      create: (context) => DeleteContactsUsecase(
        contactsRepository: context.read<ContactsRepository>(),
      ),
    ),
  ];
}
