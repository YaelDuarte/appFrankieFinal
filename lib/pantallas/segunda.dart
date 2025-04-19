import 'package:flutter/material.dart';

class Otra extends StatelessWidget {
  const Otra({super.key, required this.title, required this.nombre});
  final String title;
  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          "Hola, $nombre 👋",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
