import 'package:flutter/material.dart';

class Tarjetas extends StatefulWidget{
  Tarjetas({super.key, required this.nombre,required this.descripciones,required this.rutas});

  late List<String> nombre;
  late List<String> descripciones;
  late List<String> rutas;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}