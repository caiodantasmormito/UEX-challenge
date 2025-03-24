part of 'get_address_bloc.dart';

sealed class GetAddressState extends Equatable {
  const GetAddressState();

  @override
  List<Object?> get props => [];
}

class GetAddressInitial extends GetAddressState {}

final class GetAddressLoading extends GetAddressState {}

final class GetAddressError extends GetAddressState {
  final String? message;

  const GetAddressError({required this.message});
}

final class GetAddressSuccess extends GetAddressState {
  const GetAddressSuccess({required this.address});
  final AddressEntity address;
  @override
  List<Object> get props => [address];
}
