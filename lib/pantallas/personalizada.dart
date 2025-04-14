import 'package:flutter/material.dart';

class personalizada extends StatefulWidget{
  const personalizada({super.key,required this.title});
  final String title;

  @override
  State <personalizada> createState() => _PersonalizadaState();
}

class _PersonalizadaState extends State<personalizada>{
  final TextEditingController _control = TextEditingController();
  String _nombre = "";

  void _enviarNombre(){
    setState(() {
      _nombre = _control.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bienvenido, $_nombre")),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "BIENVENIDO",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _control,
              decoration: InputDecoration(
                  labelText: "Ingresa tu nombre",
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enviarNombre,
              child: Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }
}