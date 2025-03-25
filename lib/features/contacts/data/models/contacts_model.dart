import 'dart:convert';

import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

final class ContactsModel extends ContactsEntity {
  const ContactsModel(
      {required super.name,
      required super.number,
      required super.cep,
      required super.address,
      required super.cpf,
      required super.district,
      required super.city,
      required super.uf,
      required super.phone,
      required super.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'cpf': cpf,
      'address': address,
      'cep': cep,
      'city': city,
      'uf': uf,
      'district': district,
      'phone': phone,
    };
  }

  factory ContactsModel.fromMap(Map<String, dynamic> map) {
    return ContactsModel(
      id: map['id'] ?? '',
      number: map['number'] ?? '',
      name: map['name'] ?? '',
      cpf: map['cpf'] ?? '',
      address: map['address'] ?? '',
      cep: map['cep'] ?? '',
      district: map['district'] ?? '',
      uf: map['uf'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ContactsModel.fromJson(String source) =>
      ContactsModel.fromMap(json.decode(source));
}
