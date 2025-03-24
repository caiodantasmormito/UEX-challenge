import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc()
      : super(const LocationState(
          currentPosition: LocationState.defaultPosition,
          selectedPosition: LocationState.defaultPosition,
        )) {
    on<GetCurrentLocation>(_onGetCurrentLocation);
    on<UpdateSelectedLocation>(_onUpdateSelectedLocation);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(
      status: LocationStatus.loading,
      errorMessage: null,
    ));

    debugPrint('Obtendo localização atual...');

    try {
      final position = await _getUserPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      debugPrint('Localização obtida: $latLng');

      emit(state.copyWith(
        status: LocationStatus.success,
        currentPosition: latLng,
        selectedPosition: latLng,
      ));
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');

      emit(state.copyWith(
        status: LocationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateSelectedLocation(
    UpdateSelectedLocation event,
    Emitter<LocationState> emit,
  ) {
    debugPrint('Atualizando localização selecionada para: ${event.position}');

    emit(state.copyWith(
      selectedPosition: event.position,
    ));
  }

  Future<Position> _getUserPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desativado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão permanentemente negada.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
