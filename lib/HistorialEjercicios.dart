// ignore_for_file: file_names, unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistorialEjercicios extends StatefulWidget {
  final String ejercicio;

  const HistorialEjercicios({Key? key, required this.ejercicio})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistorialEjerciciosState createState() => _HistorialEjerciciosState();
}

class _HistorialEjerciciosState extends State<HistorialEjercicios> {
  late Future<List<Map<String, dynamic>>> _historial;

  @override
  void initState() {
    super.initState();
    _historial = _obtenerHistorial(widget.ejercicio);
  }

  Future<List<Map<String, dynamic>>> _obtenerHistorial(String ejercicio) async {
    var user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> registros = [];
    double maxPr = 0; // Variable para almacenar el máximo PR

    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('registrosEjercicios')
          .where('userId', isEqualTo: user.uid)
          .where('ejercicio', isEqualTo: ejercicio)
          .orderBy('fecha', descending: true)
          .get();

      for (var doc in querySnapshot.docs) {
        // ignore: unnecessary_cast
        var data = doc.data() as Map<String, dynamic>;
        DateTime fecha = (data['fecha'] as Timestamp).toDate();
        double peso = data['peso'] as double;
        double pr = data['pr'] as double;
        maxPr = max(maxPr, pr); // Actualiza el máximo pr

        registros.add({
          'series': data['series'],
          'repeticiones': data['repeticiones'],
          'peso': peso,
          'fecha': fecha,
          'pr': pr,
        });
      }

      // Añade la bandera de máximo PR a cada registro
      for (var registro in registros) {
        registro['isMaxPr'] = registro['pr'] == maxPr;
      }
    }

    return registros;
  }

  Future<void> _borrarHistorial(String ejercicio) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('registrosEjercicios')
          .where('userId', isEqualTo: user.uid)
          .where('ejercicio', isEqualTo: ejercicio)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _historial = _obtenerHistorial(widget.ejercicio);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de ${widget.ejercicio}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar'),
                    content: const Text(
                        '¿Deseas borrar todo el historial de este ejercicio?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Borrar'),
                        onPressed: () {
                          _borrarHistorial(widget.ejercicio);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historial,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay registros.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var registro = snapshot.data![index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DateFormat('dd/MM/yyyy').format(registro['fecha']),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.line_weight, color: Colors.grey[700]),
                          const SizedBox(width: 5),
                          Text(
                            'Series: ${registro['series']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.repeat, color: Colors.grey[700]),
                          const SizedBox(width: 5),
                          Text(
                            'Repeticiones: ${registro['repeticiones']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.fitness_center, color: Colors.grey[700]),
                          const SizedBox(width: 5),
                          Text(
                            'Peso: ${registro['peso']} kg',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rate, color: Colors.yellow[700]),
                          const SizedBox(width: 5),
                          Text(
                            '${registro['pr']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: registro['isMaxPr']
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
