import 'package:uex_app/features/address/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel(
      {required super.cep,
      required super.logradouro,
      required super.complemento,
      required super.unidade,
      required super.localidade,
      required super.uf,
      required super.estado,
      required super.ddd,
      required super.bairro});

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      complemento: map['complemento'] ?? '',
      unidade: map['unidade'] ?? '',
      localidade: map['localidade'] ?? '',
      uf: map['uf'] ?? '',
      estado: map['estado'] ?? '',
      ddd: map['ddd'] ?? '',
      bairro: map['bairro'] ?? '',
    );
  }
}
