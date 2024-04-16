// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'AnadirEjercicio.dart';
import 'HistorialEjercicios.dart';

class EjercicioDetalle extends StatefulWidget {
  final String tituloEjercicio;

  const EjercicioDetalle({Key? key, required this.tituloEjercicio})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EjercicioDetalleState createState() => _EjercicioDetalleState();
}

class _EjercicioDetalleState extends State<EjercicioDetalle> {
  void _eliminarEjercicio(String ejercicioNombre) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Obtiene una referencia a la colección de ejercicios personalizados
        var collectionEjercicios =
            FirebaseFirestore.instance.collection('ejerciciosPersonalizados');
        // Busca los documentos que coincidan con los criterios
        var snapshotEjercicios = await collectionEjercicios
            .where('userId', isEqualTo: user.uid)
            .where('nombre', isEqualTo: ejercicioNombre)
            .where('grupoMuscular',
                isEqualTo: widget.tituloEjercicio.toLowerCase())
            .get();

        // Elimina cada ejercicio personalizado encontrado
        for (var doc in snapshotEjercicios.docs) {
          await doc.reference.delete();
        }

        // Ahora elimina los registros de ejercicios asociados
        var collectionRegistros =
            FirebaseFirestore.instance.collection('registrosEjercicios');
        var snapshotRegistros = await collectionRegistros
            .where('userId', isEqualTo: user.uid)
            .where('ejercicio', isEqualTo: ejercicioNombre)
            .get();

        for (var doc in snapshotRegistros.docs) {
          await doc.reference.delete();
        }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ejercicio y registros asociados eliminados'),
        ));

        setState(() {
          // Esto forzará a FutureBuilder a reconstruirse y obtener los ejercicios actualizados
        });
      } catch (e) {
        // ignore: avoid_print
        print(e); // Considera mostrar un mensaje de error al usuario
      }
    }
  }

  // Ejercicios comunes a todos los usuarios
  final Map<String, List<String>> ejerciciosComunes = {
    'pecho': [
      'Press de banca',
      'Press de banca inclinado',
      'Aperturas con mancuernas',
      'Fondos en paralelas',
      'Pullover con mancuerna',
      'Cruces en polea alta',
      'Press de banca declinado',
      'Flexiones de pecho',
      'Aperturas con mancuernas en banco inclinado',
      'Press de banca con máquina',
    ],
    'pierna': [
      'Sentadillas',
      'Prensa de piernas',
      'Peso muerto',
      'Extensiones de cuádriceps',
      'Curl de piernas',
      'Zancadas con mancuernas',
      'Sentadillas frontales',
      'Sentadilla búlgara',
      'Elevación de talones para gemelos',
      'Desplantes',
    ],
    'biceps': [
      'Curl de bíceps con barra',
      'Curl de bíceps con mancuernas',
      'Curl de bíceps en polea baja',
      'Curl de bíceps martillo',
      'Curl de concentración',
      'Curl de bíceps alterno',
      'Curl de bíceps predicador',
      'Curl de bíceps 21s',
      'Curl con barra Z',
      'Curl de bíceps en banco Scott',
    ],
    'triceps': [
      'Extensiones de tríceps en polea alta',
      'Fondos en paralelas',
      'Press francés',
      'Patada de tríceps con mancuerna',
      'Extensiones de tríceps con mancuerna sobre la cabeza',
      'Fondos entre bancos',
      'Extensiones de tríceps con cuerda en polea alta',
      'Press de banca con agarre cerrado',
      'Extensiones de tríceps tumbado con barra',
      'Extensiones de tríceps en polea alta con barra V',
    ],
    'espalda': [
      'Dominadas',
      'Peso muerto',
      'Remo con barra',
      'Pulldowns en polea',
      'Remo en máquina',
      'Remo con mancuerna a una mano',
      'Hiperextensiones de espalda',
      'Remo sentado con polea',
      'Pull-ups',
      'Remo T con barra',
    ],
    'hombro': [
      'Press militar con barra',
      'Elevaciones laterales con mancuernas',
      'Elevaciones frontales con mancuernas',
      'Press de hombro con mancuernas',
      'Press Arnold',
      'Remo al mentón con barra',
      'Face pulls con polea',
      'Elevaciones laterales en polea',
      'Rotaciones externas con mancuerna',
      'Elevación de mancuernas en banco inclinado',
    ],
  };

  Future<List<String>> _obtenerEjerciciosPersonalizados() async {
    var user = FirebaseAuth.instance.currentUser;
    List<String> ejerciciosPersonalizados = [];
    if (user != null) {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('ejerciciosPersonalizados')
          .where('userId', isEqualTo: user.uid)
          .where('grupoMuscular',
              isEqualTo: widget.tituloEjercicio.toLowerCase())
          .get();
      for (var doc in querySnapshot.docs) {
        ejerciciosPersonalizados.add(doc.data()['nombre'].toString());
      }
    }
    return ejerciciosPersonalizados;
  }

  Future<List<String>> _obtenerEjerciciosCombinados() async {
    List<String> ejerciciosPersonalizados =
        await _obtenerEjerciciosPersonalizados();
    List<String> ejerciciosPredeterminados =
        ejerciciosComunes[widget.tituloEjercicio.toLowerCase()] ?? [];

    // Asegurarse de que los ejercicios comunes que también están en personalizados no se dupliquen
    ejerciciosPredeterminados
        .removeWhere((e) => ejerciciosPersonalizados.contains(e));

    // Primero los ejercicios personalizados, luego los comunes
    return ejerciciosPersonalizados + ejerciciosPredeterminados;
  }

  void _mostrarDialogoRegistroEjercicio(String ejercicio) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar $ejercicio'),
          content: _DialogoRegistro(ejercicio: ejercicio),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tituloEjercicio),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    AnadirEjercicio(grupoMuscular: widget.tituloEjercicio),
              ));
              if (result == true) {
                setState(
                    () {}); // Recargar la lista después de añadir un ejercicio
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _obtenerEjerciciosCombinados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay ejercicios disponibles."));
          } else {
            // Aquí mantenemos separadas las listas para poder verificar
            final ejerciciosPersonalizadosFuturo =
                _obtenerEjerciciosPersonalizados();
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ejercicio = snapshot.data![index];
                return FutureBuilder<List<String>>(
                  future: ejerciciosPersonalizadosFuturo,
                  builder: (context, snapshotPersonalizados) {
                    bool esPersonalizado = snapshotPersonalizados.hasData &&
                        snapshotPersonalizados.data!.contains(ejercicio);
                    return Card(
                      // Usar Card para un mejor aspecto visual
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          ejercicio,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: esPersonalizado
                            ? const Icon(Icons.star, color: Colors.orange)
                            : const Icon(Icons
                                .fitness_center), // Ícono basado en si el ejercicio es personalizado o no
                        trailing: esPersonalizado
                            ? IconButton(
                                // Botón solo para ejercicios personalizados
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _eliminarEjercicio(ejercicio);
                                },
                              )
                            : null,
                        onTap: () =>
                            _mostrarDialogoRegistroEjercicio(ejercicio),
                        tileColor: esPersonalizado
                            ? Colors.grey[200]
                            : Colors
                                .white, // Color de fondo basado en el tipo de ejercicio
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class _DialogoRegistro extends StatefulWidget {
  final String ejercicio;

  const _DialogoRegistro({Key? key, required this.ejercicio}) : super(key: key);

  @override
  __DialogoRegistroState createState() => __DialogoRegistroState();
}

class __DialogoRegistroState extends State<_DialogoRegistro> {
  // Controladores para los campos de texto
  final _seriesController = TextEditingController();
  final _repeticionesController = TextEditingController();
  final _pesoController = TextEditingController();
  final _prController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _seriesController,
            decoration: const InputDecoration(labelText: 'Series'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _repeticionesController,
            decoration: const InputDecoration(labelText: 'Repeticiones'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _pesoController,
            decoration: const InputDecoration(labelText: 'Peso (kg)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _prController,
            decoration:
                const InputDecoration(labelText: 'PR (Personal Record)'),
            keyboardType: TextInputType.number,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _guardarRegistroEjercicio(
                    widget.ejercicio,
                    int.tryParse(_seriesController.text) ?? 0,
                    int.tryParse(_repeticionesController.text) ?? 0,
                    double.tryParse(_pesoController.text) ?? 0.0,
                    double.tryParse(_prController.text) ?? 0.0,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Cierra el diálogo actual
                },
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navega hacia la pantalla de historial de ejercicios
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          HistorialEjercicios(ejercicio: widget.ejercicio),
                    ),
                  );
                },
                child: const Text('Historial'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _guardarRegistroEjercicio(String ejercicio, int series,
      int repeticiones, double peso, double pr) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('registrosEjercicios').add({
        'userId': user.uid,
        'email': user.email,
        'ejercicio': ejercicio,
        'series': series,
        'repeticiones': repeticiones,
        'peso': peso,
        'pr': pr,
        'fecha': Timestamp.now(),
      });
    }
  }
}
