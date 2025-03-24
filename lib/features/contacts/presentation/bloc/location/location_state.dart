part of 'location_bloc.dart';

enum LocationStatus { initial, loading, success, failure }

class LocationState extends Equatable {
  final LocationStatus status;
  final LatLng? currentPosition;
  final LatLng? selectedPosition;
  final String? errorMessage;

  static const LatLng defaultPosition = LatLng(-23.5505, -46.6333);

  const LocationState({
    this.status = LocationStatus.initial,
    this.currentPosition,
    this.selectedPosition,
    this.errorMessage,
  });

  LocationState copyWith({
    LocationStatus? status,
    LatLng? currentPosition,
    LatLng? selectedPosition,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      currentPosition: currentPosition ?? this.currentPosition,
      selectedPosition: selectedPosition ?? this.selectedPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  LatLng get effectivePosition =>
      selectedPosition ?? currentPosition ?? defaultPosition;

  @override
  List<Object?> get props =>
      [status, currentPosition, selectedPosition, errorMessage];
}
