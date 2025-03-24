import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_usecase.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:uex_app/features/contacts/domain/usecases/add_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:uex_app/features/contacts/presentation/bloc/add_contacts/add_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/get_contacts/get_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/pages/add_contacts_page.dart';
import 'package:uex_app/features/home/presentation/pages/home_page.dart';

sealed class ContactsRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<AddContactsBloc>(
            create: (context) => AddContactsBloc(
              useCase: context.read<AddContactsUsecase>(),
            ),
          ),
          BlocProvider<GetContactsBloc>(
            create: (context) => GetContactsBloc(
              useCase: context.read<GetContactsUsecase>(),
            ),
          ),
          BlocProvider<GetAddressBloc>(
            create: (context) => GetAddressBloc(
              useCase: context.read<GetAddressUsecase>(),
            ),
          ),
        ],
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: AddContactsPage.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<AddContactsBloc>(
            create: (context) => AddContactsBloc(
              useCase: context.read<AddContactsUsecase>(),
            ),
          ),
          BlocProvider<GetAddressBloc>(
            create: (context) => GetAddressBloc(
              useCase: context.read<GetAddressUsecase>(),
            ),
          ),
        ],
        child: const AddContactsPage(),
      ),
    ),
  ];
}
