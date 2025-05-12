import 'package:flutter/material.dart';
import 'package:myapp/pantallas/principal.dart';
import 'package:myapp/pantallas/segunda.dart';
import 'package:myapp/pantallas/calculadora.dart';
import 'package:myapp/pantallas/localizacion.dart';
import 'package:myapp/pantallas/ingreso.dart';
import 'package:myapp/pantallas/calendario.dart';
import 'package:myapp/pantallas/personalizada.dart';

class Navegador extends StatefulWidget {
  const Navegador({super.key});

  @override
  State<Navegador> createState() => _NavegadorState();
}

class _NavegadorState extends State<Navegador> {
  int _p = 0;
  late Widget _cuerpo; // Inicialización tardía

  void _cambiaPantalla(int i) {
    setState(() {
      _p = i;
      switch (_p) {
        case 0:
          _cuerpo = Principal(title: "Principal");
          break;
        case 1:
          _cuerpo = Otra(title: "La otra pantalla", nombre: "");
          break;
        case 2:
          _cuerpo = Calculadora(title: "Calculadora");
          break;
        case 3:
          _cuerpo = bienvenida(title: "Ingreso");
          break;
        case 4:
          _cuerpo = Localizacion(title: "GPS");
        case 5:
          _cuerpo = Calendario(title: "Calendario");
        case 6:
          _cuerpo = personalizada(title: "Tarjetas");
        default:
          _cuerpo = Principal(title: "Principal");
      }
    });
  }

  @override
  void initState() {
    super.initState(); // Siempre llamar a super.initState()
    _cuerpo = Principal(title: "Principal");
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
          BottomNavigationBarItem(
              icon: Icon(Icons.table_bar),
            label: 'Tarjetas Perosnalizadas',
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
