import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'darse_baja.dart';

class HorarioClases extends StatefulWidget {
  const HorarioClases({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HorarioClasesState createState() => _HorarioClasesState();
}

class _HorarioClasesState extends State<HorarioClases> {
  final List<Map<String, dynamic>> clases = [
    {'nombre': 'Boxeo', 'imagen': 'assets/boxeo.jpg'},
    {'nombre': 'Zumba', 'imagen': 'assets/zumba.jpg'},
    {'nombre': 'Body Combat', 'imagen': 'assets/bodycombat.jpg'},
    {'nombre': 'Yoga', 'imagen': 'assets/yoga.jpg'},
    {'nombre': 'Pilates', 'imagen': 'assets/pilates.jpg'},
    {'nombre': 'Crossfit', 'imagen': 'assets/crossfit.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clases'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: clases.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return tarjetaClase(context, clases[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:
                  verificarInscripcionesAntesDeDarseDeBaja, // Actualizado para llamar a la función de verificación
              // ignore: sort_child_properties_last
              child: const Text('Mis clases'),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                backgroundColor: Colors.blue, // Define el color del botón
                minimumSize:
                    const Size.fromHeight(50), // Define la altura del botón
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tarjetaClase(BuildContext context, Map<String, dynamic> clase) {
    return Card(
      child: InkWell(
        onTap: () => mostrarDialogoHorario(context, clase),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(clase['imagen']),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              clase['nombre'],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void mostrarDialogoHorario(BuildContext context, Map<String, dynamic> clase) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

final opciones = {
  'Boxeo': [
    'Lunes a las 06:00',
    'Martes a las 07:00',
    'Miércoles a las 18:00',
    'Jueves a las 19:00',
    'Viernes a las 17:00',
    'Sábado a las 09:00'
  ],
  'Zumba': [
    'Lunes a las 08:00',
    'Martes a las 18:00',
    'Miércoles a las 19:00',
    'Jueves a las 06:00',
    'Viernes a las 07:00',
    'Domingo a las 09:00'
  ],
  'Body Combat': [
    'Lunes a las 17:00',
    'Martes a las 06:00',
    'Miércoles a las 07:00',
    'Jueves a las 18:00',
    'Viernes a las 19:00',
    'Sábado a las 10:00'
  ],
  'Yoga': [
    'Lunes a las 19:00',
    'Martes a las 17:00',
    'Miércoles a las 06:00',
    'Jueves a las 07:00',
    'Viernes a las 18:00',
    'Domingo a las 10:00'
  ],
  'Pilates': [
    'Lunes a las 07:00',
    'Martes a las 19:00',
    'Miércoles a las 17:00',
    'Jueves a las 06:00',
    'Viernes a las 08:00',
    'Sábado a las 11:00'
  ],
  'Crossfit': [
    'Lunes a las 18:00',
    'Martes a las 08:00',
    'Miércoles a las 19:00',
    'Jueves a las 17:00',
    'Viernes a las 06:00',
    'Domingo a las 08:00'
  ],
};


    final claseSeleccionada = clase['nombre'];
    final horarios = opciones[claseSeleccionada] ?? [];
    List<bool> seleccionados = List<bool>.filled(horarios.length, false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Selecciona el horario para ${clase['nombre']}'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: List<Widget>.generate(horarios.length, (index) {
                    return CheckboxListTile(
                      title: Text(horarios[index]),
                      value: seleccionados[index],
                      onChanged: (bool? value) {
                        setState(() {
                          seleccionados[index] = value!;
                        });
                      },
                    );
                  }),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Apuntarse'),
                  onPressed: () async {
                    List<String> horariosSeleccionados = [];
                    for (int i = 0; i < seleccionados.length; i++) {
                      if (seleccionados[i])
                        // ignore: curly_braces_in_flow_control_structures
                        horariosSeleccionados.add(horarios[i]);
                    }

                    if (horariosSeleccionados.isNotEmpty) {
                      await inscribirseAClase(user.uid, user.email!,
                          claseSeleccionada, horariosSeleccionados);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> inscribirseAClase(String userId, String email,
      String claseNombre, List<String> horariosSeleccionados) async {
    final firestore = FirebaseFirestore.instance;

    bool yaInscrito = false;
    for (String horario in horariosSeleccionados) {
      // Verificar si ya existe una inscripción para este usuario, clase y horario
      final inscripcionExistente = await firestore
          .collection('inscripciones')
          .where('userId', isEqualTo: userId)
          .where('claseNombre', isEqualTo: claseNombre)
          .where('horario', isEqualTo: horario)
          .get();

      if (inscripcionExistente.docs.isEmpty) {
        // Si no existe, proceder a inscribir
        await firestore.collection('inscripciones').add({
          'userId': userId,
          'email': email,
          'claseNombre': claseNombre,
          'horario': horario,
          'fechaInscripcion': FieldValue.serverTimestamp(),
        });
      } else {
        yaInscrito = true;
        break; // Romper el ciclo si ya encuentra una inscripción, no necesita seguir buscando
      }
    }

    if (!yaInscrito) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Inscrito en $claseNombre para los horarios seleccionados')));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Ya estás inscrito en $claseNombre para uno o más de los horarios seleccionados')));
    }
  }

  void verificarInscripcionesAntesDeDarseDeBaja() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final inscripcionesSnapshot = await FirebaseFirestore.instance
          .collection('inscripciones')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (inscripcionesSnapshot.docs.isNotEmpty) {
        // Navegar a la página de darse de baja si el usuario está inscrito en alguna clase
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DarseDeBaja()));
      } else {
        // Mostrar un mensaje si el usuario no está inscrito en ninguna clase
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No estás inscrito en ninguna clase')));
      }
    }
  }
}
