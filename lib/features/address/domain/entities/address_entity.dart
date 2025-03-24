import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String cep;
  final String logradouro;
  final String complemento;
  final String unidade;
  final String bairro;
  final String localidade;
  final String uf;
  final String estado;
  
  
  
  final String ddd;
  

  const AddressEntity({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.unidade,
    required this.localidade,
    required this.uf,
    required this.estado,
   required this.ddd,
    required this.bairro,
  });

  @override
  List<Object?> get props => [
        cep,
        logradouro,
        complemento,
        unidade,
        bairro,
        localidade,
        uf,
        estado,
        ddd,
        
      ];
}
