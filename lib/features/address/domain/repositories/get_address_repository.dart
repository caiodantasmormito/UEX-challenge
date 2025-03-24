import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';

abstract class GetAddressRepository {
  Future<(Failure?, AddressEntity?)> getAddress({required String cep});
  Future<(Failure?, List<AddressEntity>?)> getAddressByUF(
      {required String uf, required String city, required String address});
}
