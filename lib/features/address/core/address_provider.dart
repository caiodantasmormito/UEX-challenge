import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uex_app/core/infra/http_client.dart';
import 'package:uex_app/features/address/data/datasources/get_address_datasource.dart';
import 'package:uex_app/features/address/data/datasources/get_address_datasource_impl.dart';
import 'package:uex_app/features/address/data/repositories/get_address_repository_impl.dart';
import 'package:uex_app/features/address/domain/repositories/get_address_repository.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_by_uf_usecase.dart';
import 'package:uex_app/features/address/domain/usecases/get_address_usecase.dart';

sealed class AddressInject {
  static final List<Provider> providers = [
    Provider<GetAddressDatasource>(
      create: (context) => GetAddressDatasourceImpl(
          client: context.read<AuthenticatedClient>(),
          localStorage: context.read<SharedPreferences>()),
    ),
    Provider<GetAddressRepository>(
      create: (context) => GetAddressRepositoryImpl(
          getAddressDataSource: context.read<GetAddressDatasource>()),
    ),
    Provider<GetAddressUsecase>(
      create: (context) => GetAddressUsecase(
        getAddressRepository: context.read<GetAddressRepository>(),
      ),
    ),
    Provider<GetAddressByUfUsecase>(
      create: (context) => GetAddressByUfUsecase(
        repository: context.read<GetAddressRepository>(),
      ),
    ),
  ];
}
