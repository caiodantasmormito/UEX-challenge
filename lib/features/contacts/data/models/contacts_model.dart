import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uex_app/features/contacts/domain/entities/contacts_entity.dart';

final class ContactsModel extends ContactsEntity {
  const ContactsModel(
      {required super.name,
      required super.cep,
      required super.coordinates,
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
      'name': name,
      'cpf': cpf,
      'address': address,
      'cep': cep,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'city': city,
      'uf': uf,
      'district': district,
      'phone': phone,
    };
  }

  factory ContactsModel.fromMap(Map<String, dynamic> map) {
    return ContactsModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      cpf: map['cpf'] ?? '',
      address: map['address'] ?? '',
      cep: map['cep'] ?? '',
      coordinates: _parseCoordinates(map),
      district: map['district'] ?? '',
      uf: map['uf'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  static LatLng _parseCoordinates(Map<String, dynamic> map) {
    try {
      final lat = map['latitude'] ?? map['coordinates']?['latitude'] ?? 0;
      final lng = map['longitude'] ?? map['coordinates']?['longitude'] ?? 0;

      return LatLng(
        double.tryParse(lat.toString()) ?? 0.0,
        double.tryParse(lng.toString()) ?? 0.0,
      );
    } catch (e) {
      return const LatLng(0, 0);
    }
  }

  String toJson() => jsonEncode(toMap());

  factory ContactsModel.fromJson(String source) =>
      ContactsModel.fromMap(json.decode(source));
}
