import 'package:uex_app/core/domain/failure/failure.dart';
import 'package:uex_app/core/domain/usecase/usecase.dart';
import 'package:uex_app/features/address/domain/entities/address_entity.dart';
import 'package:uex_app/features/address/domain/repositories/get_address_repository.dart';

class GetAddressUsecase implements UseCase<AddressEntity, String> {
  final GetAddressRepository _getAddressRepository;
  GetAddressUsecase({required GetAddressRepository getAddressRepository})
      : _getAddressRepository = getAddressRepository;

  @override
  Future<(Failure?, AddressEntity?)> call(String cep) =>
      _getAddressRepository.getAddress(cep: cep);
}
