import 'package:provider/provider.dart';
import 'package:uex_app/features/contacts/data/datasources/add_contacts_datasource/add_contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/datasources/add_contacts_datasource/add_contacts_datasource_impl.dart';
import 'package:uex_app/features/contacts/data/datasources/get_contacts_datasource/get_contacts_datasource.dart';
import 'package:uex_app/features/contacts/data/datasources/get_contacts_datasource/get_contacts_datasource_impl.dart';
import 'package:uex_app/features/contacts/data/repositories/add_contacts_repository_impl.dart';
import 'package:uex_app/features/contacts/data/repositories/get_contacts_repository_impl.dart';
import 'package:uex_app/features/contacts/domain/repositories/add_contacts_repository.dart';
import 'package:uex_app/features/contacts/domain/repositories/get_contacts_repository.dart';
import 'package:uex_app/features/contacts/domain/usecases/add_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/get_contacts_usecase.dart';

sealed class ContactsInject {
  static final List<Provider> providers = [
    Provider<AddContactsDatasource>(
      create: (context) => AddContactsDatasourceImpl(),
    ),
    Provider<AddContactsRepository>(
      create: (context) => AddContactsRepositoryImpl(
          addContactsDataSource: context.read<AddContactsDatasource>()),
    ),
    Provider<AddContactsUsecase>(
      create: (context) => AddContactsUsecase(
        repository: context.read<AddContactsRepository>(),
      ),
    ),
    Provider<GetContactsDatasource>(
      create: (context) => GetContactsDatasourceImpl(),
    ),
    Provider<GetContactsRepository>(
      create: (context) => GetContactsRepositoryImpl(
          getContactsDataSource: context.read<GetContactsDatasource>()),
    ),
    Provider<GetContactsUsecase>(
      create: (context) => GetContactsUsecase(
        getContactsRepository: context.read<GetContactsRepository>(),
      ),
    ),
  ];
}
