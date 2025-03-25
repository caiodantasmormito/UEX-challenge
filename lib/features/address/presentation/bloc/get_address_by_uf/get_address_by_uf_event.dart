part of 'get_address_by_uf_bloc.dart';

sealed class GetAddressByUfEvent extends Equatable {
  const GetAddressByUfEvent();
}

final class AddressByUf extends GetAddressByUfEvent {
  const AddressByUf({required this.params});
  final GetAddressParams params;

  @override
  List<Object> get props => [params];
}
