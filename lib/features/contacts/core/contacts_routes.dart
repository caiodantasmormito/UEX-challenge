import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_by_uf_usecase.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_usecase.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_bloc.dart';
import 'package:uex_app/features/address/presentation/bloc/get_address_by_uf/get_address_by_uf_bloc.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';
import 'package:uex_app/features/contacts/domain/usecases/add_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/delete_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:uex_app/features/contacts/domain/usecases/update_contacts_usecase.dart';
import 'package:uex_app/features/contacts/presentation/bloc/add_contacts/add_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/delete_contacts/delete_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/get_contacts/get_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/location/location_bloc.dart';
import 'package:uex_app/features/contacts/presentation/bloc/update_contacts/update_contacts_bloc.dart';
import 'package:uex_app/features/contacts/presentation/pages/add_contacts_page.dart';
import 'package:uex_app/features/contacts/presentation/pages/edit_contacts_page.dart';
import 'package:uex_app/features/contacts/presentation/pages/map_selector_page.dart';
import 'package:uex_app/features/home/presentation/pages/home_page.dart';

sealed class ContactsRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<UpdateContactsBloc>(
            create: (context) => UpdateContactsBloc(
              useCase: context.read<UpdateContactsUsecase>(),
            ),
          ),
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
          BlocProvider<DeleteContactsBloc>(
            create: (context) => DeleteContactsBloc(
              useCase: context.read<DeleteContactsUsecase>(),
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
          BlocProvider<GetAddressByUfBloc>(
            create: (context) => GetAddressByUfBloc(
              useCase: context.read<GetAddressByUfUsecase>(),
            ),
          ),
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
          BlocProvider<LocationBloc>(
            create: (context) => LocationBloc(),
          ),
        ],
        child: const AddContactsPage(),
      ),
    ),
    GoRoute(
        path: UpdateContactsPage.routeName,
        builder: (context, state) {
          final contact = state.extra as ContactsEntity;
          return MultiBlocProvider(
            providers: [
              BlocProvider<UpdateContactsBloc>(
                create: (context) => UpdateContactsBloc(
                  useCase: context.read<UpdateContactsUsecase>(),
                ),
              ),
              BlocProvider<GetAddressByUfBloc>(
                create: (context) => GetAddressByUfBloc(
                  useCase: context.read<GetAddressByUfUsecase>(),
                ),
              ),
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
            child: UpdateContactsPage(contact: contact),
          );
        }),
    GoRoute(
      path: MapSelector.routeName,
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
          BlocProvider<LocationBloc>(
            create: (context) => LocationBloc(),
          ),
        ],
        child: const MapSelector(),
      ),
    ),
  ];
}
