import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/repositories/get_address_repository.dart';

class GetAddressByUfUsecase
    implements UseCase<List<AddressEntity>, GetAddressParams> {
  final GetAddressRepository _repository;
  GetAddressByUfUsecase({required GetAddressRepository repository})
      : _repository = repository;

  @override
  Future<(Failure?, List<AddressEntity>?)> call(GetAddressParams params) =>
      _repository.getAddressByUF(
          uf: params.uf, city: params.city, address: params.address);
}

class GetAddressParams {
  final String uf;
  final String city;
  final String address;

  GetAddressParams({
    required this.uf,
    required this.city,
    required this.address,
  });
}
