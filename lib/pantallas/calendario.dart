import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key, required this.title});
  final String title;

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime _fechaSeleccionada = DateTime.now();

  final Map<DateTime, List<Map<String, dynamic>>> _eventos = {};

  // Función para cargar los eventos y sean visibles en el calendario
  @override
  void initState() {
    super.initState();
    _cargarEventosDesdeFirestore();
  }

  List<Map<String, dynamic>> _obtenerEventosDelDia(DateTime fecha) {
    return _eventos[DateTime.utc(fecha.year, fecha.month, fecha.day)] ?? [];
  }


  /*
  Funcion general donde se mandaran a cargar los eventos que han sido guardados en la BD
  Llamando asi al nombre,fecha y su color
   */
  Future<void> _cargarEventosDesdeFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('eventos').get();

    final Map<DateTime, List<Map<String, dynamic>>> eventosCargados = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final nombre = data['nombre'] as String;
      final fechaInicio = (data['fechaInicio'] as Timestamp).toDate();
      final fechaFin = (data['fechaFin'] as Timestamp).toDate();
      final colorHex = data['color'] as String;
      final color = Color(int.parse('FF${colorHex.substring(1)}', radix: 16));

      for (DateTime d = fechaInicio;
      !d.isAfter(fechaFin);
      d = d.add(const Duration(days: 1))) {
        final dia = DateTime.utc(d.year, d.month, d.day);
        eventosCargados.putIfAbsent(dia, () => []).add({
          'nombre': nombre,
          'color': color,
        });
      }
    }

    setState(() {
      _eventos.clear();
      _eventos.addAll(eventosCargados);
    });
  }

  /*
  Esta función es para guardar los eventos que creemos en la BD, todos seguiran este proceso y
  posteriormente se mandaran a guardar
   */
  Future<void> guardarEventoFirestore({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required Color color,
  }) async {
    final evento = {
      "nombre": nombre,
      "fechaInicio": Timestamp.fromDate(fechaInicio),
      "fechaFin": Timestamp.fromDate(fechaFin),
      "color": '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      "fechaDia": "${fechaInicio.year}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
    };

    // AQUI ES DONDE SE LLAMA A LA COLECCION DE LA BD Y SE GUARDA EL EVENTO CREADO
    await FirebaseFirestore.instance.collection('eventos').add(evento);
  }

  @override
  Widget build(BuildContext context) {
    final eventos = _obtenerEventosDelDia(_fechaSeleccionada);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarEventosDesdeFirestore,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
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
                  CalendarFormat.month: 'Mes',
                },
                eventLoader: _obtenerEventosDelDia,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: (events as List<Map<String, dynamic>>).map((evento) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: evento['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Eventos para hoy:',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (eventos.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No hay eventos para este día."),
                )
              else
                ...eventos.map((evento) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: evento['color'] as Color,
                  ),
                  title: Text(evento['nombre'] as String),
                )),
            ],
          ),
        ),
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
                child: _EventoForm(
                  onGuardar: (nombre, inicio, fin, color) async {
                    await guardarEventoFirestore(
                      nombre: nombre,
                      fechaInicio: inicio,
                      fechaFin: fin,
                      color: color,
                    );
                    await _cargarEventosDesdeFirestore();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// FUNCION PARA PODER CREAR EL MINICALENDARIO JUNTO CON EL RELOJ
class _EventoForm extends StatefulWidget {
  final void Function(String nombre, DateTime inicio, DateTime fin, Color color) onGuardar;

  const _EventoForm({required this.onGuardar});

  @override
  State<_EventoForm> createState() => _EventoFormState();
}

// FUNCION DEL BOTON DE CREAR Y GUARDAR EVENTO SOLICITANDO FECHAS Y HORAS DE INICIO Y FIN
class _EventoFormState extends State<_EventoForm> {
  final TextEditingController _nombreController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horFinal;

  Color _colorSeleccionado = Colors.blue;

  // FECHA DESDE DONDE INICIA, QUE MES MUESTRA Y DONDE ACABA EL CALENDARIO Y PARA SELECCIONAR FECHA
  Future<void> _seleccionarFecha(bool esInicio, bool hoInicio) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    // FUNCION PARA MOSTRAR EL RELOJ Y SELECCIONAR HORA
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 00, minute: 00),
    );

    if (picked != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }

    if (hora != null) {
      setState(() {
        if (hoInicio) {
          _horaInicio = hora;
        } else {
          _horFinal = hora;
        }
      });
    }
  }

  /*
  FUNCION QUE SE MUESTRA EN EL BOTON DE GUARDAR PARA QUE A LOS EVENTOS QUE VAYAMOS A CREAR
  SE LES DE UN COLOR PARA QUE PUEDAN SER IDENTIFICADOS
   */
  void _mostrarSelectorColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecciona un color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _colorSeleccionado,
            onColorChanged: (color) {
              setState(() {
                _colorSeleccionado = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))
        ],
      ),
    );
  }

  //LOGICA Y DISEÑO DEL BOTON DE GUARDAR
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
                  onPressed: () => _seleccionarFecha(true, true),
                  child: Text(_fechaInicio == null || _horaInicio == null
                      ? "Inicio"
                      : "Inicio: ${_fechaInicio!.toLocal().toString().split(' ')[0]} ${_horaInicio!.format(context)}"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _seleccionarFecha(false, false),
                  child: Text(_fechaFin == null || _horFinal == null
                      ? "Fin"
                      : "Fin: ${_fechaFin!.toLocal().toString().split(' ')[0]} ${_horFinal!.format(context)}"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _mostrarSelectorColor,
            icon: const Icon(Icons.color_lens),
            label: const Text("Color del evento"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _colorSeleccionado,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (_nombreController.text.isNotEmpty &&
                  _fechaInicio != null &&
                  _fechaFin != null) {
                final inicioCompleto = DateTime(
                  _fechaInicio!.year,
                  _fechaInicio!.month,
                  _fechaInicio!.day,
                  _horaInicio?.hour ?? 0,
                  _horaInicio?.minute ?? 0,
                );

                final finCompleto = DateTime(
                  _fechaFin!.year,
                  _fechaFin!.month,
                  _fechaFin!.day,
                  _horFinal?.hour ?? 0,
                  _horFinal?.minute ?? 0,
                );

                widget.onGuardar(
                  _nombreController.text,
                  inicioCompleto,
                  finCompleto,
                  _colorSeleccionado,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Evento '${_nombreController.text}' guardado."),
                  ),
                );
              }
            },
            child: const Text("Guardar"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

