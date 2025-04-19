import 'package:flutter/material.dart';
import 'package:myapp/pantallas/segunda.dart';

class bienvenida extends StatefulWidget {
  const bienvenida({super.key, required this.title});
  final String title;

  @override
  State<bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<bienvenida> {
  final TextEditingController _control = TextEditingController();

  void _enviarNombre() {
    String nombre = _control.text;

    if (nombre.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Otra(title: "Segunda Pantalla", nombre: nombre),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa tu nombre")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "BIENVENIDO",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _control,
              decoration: const InputDecoration(
                labelText: "Ingresa tu nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarNombre,
              child: const Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}
