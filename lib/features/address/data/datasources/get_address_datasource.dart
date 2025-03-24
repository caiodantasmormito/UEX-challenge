import 'package:uex_app/features/address/data/model/address_model.dart';

abstract interface class GetAddressDatasource {
  Future<AddressModel> getAddress({required String cep});

  Future<List<AddressModel>> getAddressByUF({required String uf, required String city, required String address});
}
