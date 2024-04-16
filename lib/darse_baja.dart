import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClaseInscrita {
  String id;
  String nombre;
  String horario;
  bool seleccionada;

  ClaseInscrita({
    required this.id,
    required this.nombre,
    required this.horario,
    this.seleccionada = false,
  });
}

// ignore: use_key_in_widget_constructors
class DarseDeBaja extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _DarseDeBajaState createState() => _DarseDeBajaState();
}

class _DarseDeBajaState extends State<DarseDeBaja> {
  String? motivoDeBaja;
  List<String> motivos = [
    "No me gusta",
    "Es muy caro",
    "Cambio de horario",
    "Otro"
  ];
  final TextEditingController _otroMotivoController = TextEditingController();
  List<ClaseInscrita> clasesInscritas = [];

  @override
  void initState() {
    super.initState();
    _cargarClasesInscritas();
  }

  void _cargarClasesInscritas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final inscripcionesSnapshot = await FirebaseFirestore.instance
          .collection('inscripciones')
          .where('userId', isEqualTo: user.uid)
          .get();

      final List<ClaseInscrita> tempClasesInscritas =
          inscripcionesSnapshot.docs.map((doc) {
        return ClaseInscrita(
          id: doc.id,
          nombre: doc.data()['claseNombre'] as String,
          horario: doc.data()['horario'] as String,
          seleccionada: false,
        );
      }).toList();

      setState(() {
        clasesInscritas = tempClasesInscritas;
      });
    }
  }

  bool _alMenosUnaClaseSeleccionada() {
    return clasesInscritas.any((clase) => clase.seleccionada);
  }

  void _procesarBaja() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Eliminar las inscripciones seleccionadas
    for (var clase in clasesInscritas.where((clase) => clase.seleccionada)) {
      await FirebaseFirestore.instance
          .collection('inscripciones')
          .doc(clase.id)
          .delete();
    }

    // Añadir registro en la colección 'bajas'
    await FirebaseFirestore.instance.collection('bajas').add({
      'userId': user.uid,
      'email': user.email,
      'motivo':
          motivoDeBaja == "Otro" ? _otroMotivoController.text : motivoDeBaja,
      'clasesDadasDeBaja': clasesInscritas
          .where((clase) => clase.seleccionada)
          .map((e) => "${e.nombre} - ${e.horario}")
          .toList(),
      'fecha': Timestamp.now(),
    });

    // Mostrar un mensaje de confirmación
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Baja procesada con éxito')));

    // Navegar de regreso
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis clases"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: clasesInscritas.length,
              itemBuilder: (context, index) {
                var clase = clasesInscritas[index];
                return CheckboxListTile(
                  title: Text('${clase.nombre} - ${clase.horario}'),
                  value: clase.seleccionada,
                  onChanged: (bool? newValue) {
                    setState(() {
                      clase.seleccionada = newValue!;
                    });
                  },
                );
              },
            ),
            DropdownButton<String>(
              value: motivoDeBaja,
              hint: const Text("Selecciona un motivo"),
              onChanged: (String? newValue) {
                setState(() {
                  motivoDeBaja = newValue;
                });
              },
              items: motivos.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (motivoDeBaja == "Otro")
              TextField(
                controller: _otroMotivoController,
                decoration:
                    const InputDecoration(labelText: 'Especifique aquí'),
              ),
            ElevatedButton(
              onPressed: _alMenosUnaClaseSeleccionada() ? _procesarBaja : null,
              // ignore: sort_child_properties_last
              child: const Text('Confirmar Baja'),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Colors.red,
                // ignore: deprecated_member_use
                onSurface: Colors.red.withOpacity(0.5), // Color when disabled
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
