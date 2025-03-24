import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/location/location_bloc.dart';

class MapSelector extends StatefulWidget {
  const MapSelector({super.key});
  static const String routeName = '/maps';

  @override
  State<MapSelector> createState() => _MapSelectorState();
}

class _MapSelectorState extends State<MapSelector> {
  @override
  void initState() {
    context.read<LocationBloc>().add(GetCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return Column(
          children: [
            const Text(
              'Selecione a localização no mapa:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildMapContent(state, context),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Usar minha localização atual'),
              onPressed: () =>
                  context.read<LocationBloc>().add(GetCurrentLocation()),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMapContent(LocationState state, BuildContext context) {
    if (state.status == LocationStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final position = state.effectivePosition ?? LatLng(-23.5505, -46.6333);

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
        controller.animateCamera(
          CameraUpdate.newLatLng(position),
        );
      },
    );
  }

  double _calculateZoom(LocationState state) {
    if (state.selectedPosition != null) return 15;
    if (state.currentPosition != null) return 12;
    return 10;
  }
}
