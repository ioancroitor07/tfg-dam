import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CentrosGimnasio extends StatefulWidget {
  const CentrosGimnasio({Key? key}) : super(key: key);

  @override
  State<CentrosGimnasio> createState() => _CentrosGimnasioState();
}

class _CentrosGimnasioState extends State<CentrosGimnasio> {
  final LatLng _center = const LatLng(40.45280909123708, -3.660805995124805);

  // Crea un conjunto de marcadores, inicialmente vacío
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Añade un marcador al conjunto de marcadores
    _markers.add(
      Marker(
        // Proporciona un identificador único para este marcador
        markerId: const MarkerId('centro_gimnasio'),
        // Usa las coordenadas del centro para la posición del marcador
        position: _center,
        // Opcional: Añade un título e información al marcador si deseas que aparezca al tocar
        infoWindow: const InfoWindow(
          title: 'GYM',
          snippet: 'Aquí está tu gimnasio',
        ),
        // Opcional: Personaliza el icono del marcador
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GYM'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        // Añade el conjunto de marcadores al mapa
        markers: _markers,
      ),
    );
  }
}
