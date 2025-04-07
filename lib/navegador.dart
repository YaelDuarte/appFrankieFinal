import 'package:flutter/material.dart';
import 'package:myapp/pantallas/principal.dart';
import 'package:myapp/pantallas/segunda.dart';
import 'package:myapp/pantallas/calculadora.dart';
import 'package:myapp/pantallas/localizacion.dart';
import 'package:myapp/pantallas/ingreso.dart';
import 'package:myapp/pantallas/calendario.dart';

class Navegador extends StatefulWidget {
  const Navegador({super.key});

  @override
  State<Navegador> createState() => _NavegadorState();
}

class _NavegadorState extends State<Navegador> {
  int _p = 0;
  late Widget _cuerpo; // Inicialización tardía para evitar null

  void _cambiaPantalla(int i) {
    setState(() {
      _p = i;
      switch (_p) {
        case 0:
          _cuerpo = Principal(title: "Principal");
          break;
        case 1:
          _cuerpo = Otra(title: "La otra pantalla");
          break;
        case 2:
          _cuerpo = Calculadora(title: "Calculadora");
          break;
        case 3:
          _cuerpo = bienvenida(title: "Ingreso"); // Cambié a 'Bienvenida'
          break;
        case 4:
          _cuerpo = Localizacion(title: "Estilo GPS");
        case 5:
          _cuerpo = Calendario(title: "Calendario");
        default:
          _cuerpo = Principal(title: "Principal");
      }
    });
  }

  @override
  void initState() {
    super.initState(); // Siempre llamar a super.initState()
    _cuerpo = Principal(title: "Principal"); // Inicialización correcta
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cuerpo,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Segunda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculadora',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Ingreso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed_outlined),
            label: 'GPS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
        ],
        backgroundColor: Colors.grey, // Asegurar fondo visible
        currentIndex: _p,
        selectedItemColor: Colors.orange[900],
        unselectedItemColor: Colors.blueGrey,
        onTap: _cambiaPantalla,
      ),
    );
  }
}
