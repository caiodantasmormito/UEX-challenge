part of 'get_address_by_uf_bloc.dart';

sealed class GetAddressByUfState extends Equatable {
  const GetAddressByUfState();

  @override
  List<Object?> get props => [];
}

class GetAddressByUfInitial extends GetAddressByUfState {}

final class GetAddressByUfLoading extends GetAddressByUfState {}

final class GetAddressByUfError extends GetAddressByUfState {
  final String? message;

  const GetAddressByUfError({required this.message});
}

final class GetAddressByUfSuccess extends GetAddressByUfState {
  const GetAddressByUfSuccess({required this.addresses});
  final List<AddressEntity> addresses;
  @override
  List<Object> get props => [addresses];
}
