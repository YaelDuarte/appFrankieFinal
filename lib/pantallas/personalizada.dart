import 'package:flutter/material.dart';

class personalizada extends StatelessWidget {
  const personalizada({super.key, required String title});

  final List<Map<String, String>> tarjetas = const [
    {
      'nombre': 'Floppa Gorro',
      'descripcion': 'Le gusta comer camarones en coctel',
      'imagen': 'assets/floppaWithHat.jpg',
    },
    {
      'nombre': 'Dr Sexo',
      'descripcion': 'Doctorado en sexologia',
      'imagen': 'assets/flopaAngry.jpg',
    },
    {
      'nombre': 'Abuela Carlota',
      'descripcion': 'Experta en mudanzas express',
      'imagen': 'assets/WhatsApp Image 2025-04-03 at 7.53.04 PM.jpeg',
    },
    {
      'nombre': 'Gato agradecido',
      'descripcion': 'Agradece al gobierno munisipal de yukatan',
      'imagen': 'assets/gatoAgradecido.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(185, 33, 9, 100.0),
        title: const Text('Tarjetas'),
      ),
      body: ListView.builder(
        itemCount: tarjetas.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final tarjeta = tarjetas[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: Image.asset(
                    tarjeta['imagen']!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tarjeta['nombre']!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tarjeta['descripcion']!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
