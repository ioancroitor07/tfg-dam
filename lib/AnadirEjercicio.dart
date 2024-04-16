// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnadirEjercicio extends StatefulWidget {
  final String grupoMuscular;

  const AnadirEjercicio({Key? key, required this.grupoMuscular})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnadirEjercicioState createState() => _AnadirEjercicioState();
}

class _AnadirEjercicioState extends State<AnadirEjercicio> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Ejercicio a ${widget.grupoMuscular}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Ejercicio',
                border: OutlineInputBorder(),
                hintText: 'Introduce el nombre del ejercicio',
              ),
            ),
            const SizedBox(height: 20), // Espacio entre los elementos
            ElevatedButton(
              onPressed: _anadirEjercicio,
              child: const Text('Añadir Ejercicio'),
            ),
          ],
        ),
      ),
    );
  }

  void _anadirEjercicio() {
    final String nombreEjercicio = _nombreController.text.trim();
    if (nombreEjercicio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, introduce un nombre de ejercicio.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('ejerciciosPersonalizados').add({
        'nombre': nombreEjercicio,
        'grupoMuscular': widget.grupoMuscular.toLowerCase(),
        'userId': user.uid,
      }).then((value) {
        Navigator.pop(context,
            true); // Avisa a la página anterior que se añadió un ejercicio
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir el ejercicio: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No estás autenticado.')),
      );
    }
  }
}
