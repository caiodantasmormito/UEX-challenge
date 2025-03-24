part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocation extends LocationEvent {}

class UpdateSelectedLocation extends LocationEvent {
  final LatLng position;

  const UpdateSelectedLocation(this.position);

  @override
  List<Object> get props => [position];
}