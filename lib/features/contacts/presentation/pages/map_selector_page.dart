import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/location/location_bloc.dart';

class MapSelector extends StatefulWidget {
  final String? initialAddress;

  const MapSelector({super.key, this.initialAddress});
  static const String routeName = '/maps';

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  late GoogleMapController _mapController;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialAddress != null) {
      _addressController.text = widget.initialAddress!;
      _searchAddress();
    } else {
      context.read<LocationBloc>().add(GetCurrentLocation());
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress() async {
    if (_addressController.text.isEmpty) return;

    try {
      final locations = await geo.locationFromAddress(_addressController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final position = LatLng(location.latitude, location.longitude);

        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(position, 15),
        );

        context.read<LocationBloc>().add(UpdateSelectedLocation(position));
      }
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Endereço não encontrado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Localização do contato'),
          ),
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildMapContent(state, context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMapContent(LocationState state, BuildContext context) {
    if (state.status == LocationStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final position =
        state.effectivePosition ?? const LatLng(-23.5505, -46.6333);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: position,
        zoom: _calculateZoom(state),
      ),
      markers: {
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            context
                .read<LocationBloc>()
                .add(UpdateSelectedLocation(newPosition));
          },
        ),
      },
      onTap: (position) {
        context.read<LocationBloc>().add(UpdateSelectedLocation(position));
      },
      onMapCreated: (controller) {
        _mapController = controller;
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(position, _calculateZoom(state)),
        );
      },
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
    );
  }

  double _calculateZoom(LocationState state) {
    if (state.selectedPosition != null) return 15;
    if (state.currentPosition != null) return 14;
    return 12;
  }
}
