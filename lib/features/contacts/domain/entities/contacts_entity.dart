import 'package:equatable/equatable.dart';
import 'package:uex_app/features/contacts/data/models/contacts_model.dart';

base class ContactsEntity extends Equatable {
  final String name;
  final String address;
  final String cpf;
  final String cep;
  
  final String longitude;
  final String latitude;

  const ContactsEntity({
    
    required this.longitude,
    required this.name,
    required this.cep,
    required this.latitude,
    required this.address,
    required this.cpf,
  });

  const ContactsEntity.empty({
    this.name = '',
    this.cep = '',
    this.latitude = '',
    this.address = '',
    this.cpf = '',
    
    this.longitude = '',
  });

  @override
  List<Object?> get props => [
        name,
        cep,
        latitude,
        cpf,
        address,
        longitude,
        
      ];

  ContactsEntity copyWith({
    String? name,
    String? cep,
    String? latitude,
    String? cpf,
    String? address,
   
    String? longitude,
  }) {
    return ContactsEntity(
      name: name ?? this.name,
      cep: cep ?? this.cep,
      latitude: latitude ?? this.latitude,
      address: address ?? this.address,
      cpf: cpf ?? this.cpf, 
      
      longitude: longitude ?? this.longitude,
    );
  }

  ContactsModel toModel() => ContactsModel(
        name: name,
        cep: cep,
        latitude: latitude,
        cpf: cpf,
        address: address,
        
        longitude: longitude,
      );
}
