// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/features/address/data/datasources/get_address_datasource.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/repositories/get_address_repository.dart';
import 'package:uex_app/features/contacts/data/exceptions/exception.dart';
import 'package:uex_app/features/contacts/domain/failures/failures.dart';

class GetAddressRepositoryImpl implements GetAddressRepository {
  final GetAddressDatasource _getAddressDataSource;

  GetAddressRepositoryImpl({required GetAddressDatasource getAddressDataSource})
      : _getAddressDataSource = getAddressDataSource;

  @override
  Future<(Failure?, AddressEntity?)> getAddress({required String cep}) async {
    try {
      final result = await _getAddressDataSource.getAddress(cep: cep);
      return (null, result);
    } on GetContactsException catch (error) {
      return (
        GetContactsFailure(message: error.message),
        null,
      );
    }
  }

  @override
  Future<(Failure?, List<AddressEntity>?)> getAddressByUF ({required String uf, required String city, required String address}) async {
    try {
      final result = await _getAddressDataSource.getAddressByUF(uf: uf, city: city, address: address);
      return (null, result);
    } on GetContactsException catch (error) {
      return (
        GetContactsFailure(message: error.message),
        null,
      );
    }
  }
}
