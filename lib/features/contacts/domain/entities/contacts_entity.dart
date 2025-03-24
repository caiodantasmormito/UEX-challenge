import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

base class ContactsEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String cpf;
  final String cep;
  final LatLng coordinates;
  final String district;
  final String city;
  final String uf;
  final String phone;

  const ContactsEntity(
      {required this.id,
        required this.district,
      required this.city,
      required this.uf,
      required this.name,
      required this.cep,
      required this.coordinates,
      required this.address,
      required this.cpf,
      required this.phone});

  const ContactsEntity.empty()
      : name = '',
      id = '',
        cep = '',
        coordinates = const LatLng(0, 0),
        address = '',
        cpf = '',
        district = '',
        city = '',
        uf = '',
        phone = '';

  @override
  List<Object?> get props => [
        name,
        id,
        cep,
        coordinates,
        cpf,
        address,
        uf,
        district,
        city,
        phone,
      ];

  ContactsEntity copyWith({
    String? name,
    String? id,
    String? cep,
    LatLng? coordinates,
    String? cpf,
    String? address,
    String? city,
    String? district,
    String? uf,
    String? phone,
  }) {
    return ContactsEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      cep: cep ?? this.cep,
      coordinates: coordinates ?? this.coordinates,
      address: address ?? this.address,
      cpf: cpf ?? this.cpf,
      city: city ?? this.city,
      district: district ?? this.district,
      uf: uf ?? this.uf,
      phone: phone ?? this.phone,
    );
  }

  ContactsModel toModel() => ContactsModel(
        name: name,
        id: id,
        cep: cep,
        coordinates: coordinates,
        cpf: cpf,
        address: address,
        uf: uf,
        district: district,
        city: city,
        phone: phone,
      );
}
