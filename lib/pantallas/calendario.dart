import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key, required this.title});
  final String title;

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime _fechaSeleccionada = DateTime.now();
  final Map<DateTime, List<String>> _eventos = {};

  List<String> _obtenerEventosDelDia(DateTime fecha) {
    return _eventos[DateTime.utc(fecha.year, fecha.month, fecha.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final eventos = _obtenerEventosDelDia(_fechaSeleccionada);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendario")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(_fechaSeleccionada, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _fechaSeleccionada = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            eventLoader: _obtenerEventosDelDia,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Eventos para hoy:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          if (eventos.isEmpty)
            const Text("No hay nada para el día")
          else
            ...eventos.map((e) => ListTile(
              leading: const Icon(Icons.event),
              title: Text(e),
            ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: _EventoForm(onGuardar: (nombre, inicio, fin) {
                  setState(() {
                    for (DateTime d = inicio;
                    !d.isAfter(fin);
                    d = d.add(const Duration(days: 1))) {
                      final dia = DateTime.utc(d.year, d.month, d.day);
                      _eventos.putIfAbsent(dia, () => []).add(nombre);
                    }
                  });
                  Navigator.pop(context);
                }),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EventoForm extends StatefulWidget {
  final void Function(String nombre, DateTime inicio, DateTime fin) onGuardar;
  const _EventoForm({required this.onGuardar});

  @override
  State<_EventoForm> createState() => _EventoFormState();
}

class _EventoFormState extends State<_EventoForm> {
  final TextEditingController _nombreController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horFinal;


  // AQUI ESTA LA FUNCION DE DESPLEGAR EL CALENDARIO DENTRO DE LOS EVENTOS
  Future<void> _seleccionarFecha(bool esInicio,bool hoInicio) async {

    //FUNCION PARA CALENDARIO
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    // FUNCION PARA EL RELOJ
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour:00, minute: 00),
    );


    //IFS PARA VERIFICAR SI HAY ALGO NULO SELECCIONADO EN FECHA Y HORA
    if (picked != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }

    if(hora != null){
      setState(() {
        if(hoInicio){
          _horaInicio = hora;
        }
        else{
          _horFinal = hora;
        }
      });
    }
  }


  //APARTADO DE DISEÑO DE LOS BOTONES
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Agregar Evento",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(labelText: "Nombre del evento"),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _seleccionarFecha(true,true),
                  child: Text(_fechaInicio == null || _horaInicio == null
                      ? "Inicio"
                      : "Inicio: ${_fechaInicio!.toLocal().toString().split(' ')[0]} ${_horaInicio!.format(context)}"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _seleccionarFecha(false,false),
                  child: Text(_fechaFin == null || _horFinal == null
                      ? "Fin"
                      : "Fin: ${_fechaFin!.toLocal().toString().split(' ')[0]} ${_horFinal!.format(context)}"),
                ),

              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_nombreController.text.isNotEmpty &&
                  _fechaInicio != null &&
                  _fechaFin != null) {
                widget.onGuardar(
                    _nombreController.text, _fechaInicio!, _fechaFin!);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "El evento '${_nombreController.text}' sera el $_fechaInicio"
                        " Y finalizara el $_fechaFin",
                  ),
                ),
              );

            },
            child: const Text("Guardar"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}