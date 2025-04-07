import 'package:flutter/material.dart';
import 'package:myapp/pantallas/principal.dart';

class Otra extends StatefulWidget{
  const Otra({super.key,required this.title});
  final String title;

  @override
  State <Otra> createState() => _OtraState();
}

class _OtraState extends State<Otra>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Principal(title: "El titulo"),
    );
  }

}