part of 'get_address_bloc.dart';

sealed class GetAddressEvent extends Equatable {
  const GetAddressEvent();
}

final class Address extends GetAddressEvent {
  const Address({required this.cep});
  final String cep;

  @override
  List<Object> get props => [cep];
}
