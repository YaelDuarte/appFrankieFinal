import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Localizacion extends StatefulWidget {
  const Localizacion({super.key, required this.title});
  final String title;

  @override
  State<Localizacion> createState() => _LocalizacionState();
}

class _LocalizacionState extends State<Localizacion> {
  double? _latitud;
  double? _longitud; // 🔹 Corrección de nombre de variable

  Future<void> _obtenerCoordenadas() async {
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permiso Denegado")),
        );
        return;
      }
    }

    Position posicionAct = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best, // 🔹 Corrección aquí
      ),
    );


    setState(() {
      _latitud = posicionAct.latitude;
      _longitud = posicionAct.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text(widget.title)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Localización",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _obtenerCoordenadas,
                child: const Text("Obtener Coordenadas"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Latitud: ${_latitud ?? 'Desconocida'}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Longitud: ${_longitud ?? 'Desconocida'}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
