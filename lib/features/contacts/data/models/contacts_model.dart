import 'dart:convert';

import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

final class ContactsModel extends ContactsEntity {
  const ContactsModel(
      {
      required super.longitude,
      required super.name,
      required super.cep,
      required super.latitude,
      required super.address,
      required super.cpf});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cpf': cpf,
      'address': address,
      'latitude': latitude,
      'cep': cep,
      'longitude': longitude,
      
    };
  }

  factory ContactsModel.fromMap(Map<String, dynamic> map) {
    return ContactsModel(
        name: map['name'] ?? '',
        
        longitude: map['longitude'] ?? '',
        cep: map['cep'] ?? '',
        cpf: map['cpf'] ?? '',
        latitude: map['latitude'] ?? '',
        address: map['address'] ?? '');
  }

  String toJson() => jsonEncode(toMap());

  factory ContactsModel.fromJson(String source) =>
      ContactsModel.fromMap(json.decode(source));
}
