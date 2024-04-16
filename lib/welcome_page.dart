import 'package:flutter/material.dart';
import 'horario_clases.dart'; // Asegúrate de que este importe sea correcto según la ubicación de tu archivo
import 'ejercicios.dart'; // Importa la página de ejercicios
import 'imc.dart'; // Importa la página de imc
import 'nutricion.dart'; // Importa la página de nutrición
import 'centros_gimnasio.dart'; // Importa la página de centros de gimnasio
import 'redes_sociales.dart'; // Importa la página de redes sociales

class WelcomePage extends StatelessWidget {
  final String username;

  const WelcomePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> secciones = [
      {
        'titulo': 'Horario',
        'imagenFondo': 'assets/horario.jpg',
        'accion': () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Image.asset('assets/horario.jpg'),
              ),
            ),
      },
      {
        'titulo': 'Clases',
        'imagenFondo': 'assets/clases.jpg',
        'accion': () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HorarioClases())),
      },
      {
        'titulo': 'Ejercicios',
        'imagenFondo': 'assets/ejercicios.jpg',
        'accion': () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Ejercicios())),
      },
      {
        'titulo': 'Imc',
        'imagenFondo': 'assets/imc.jpg',
        'accion': () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Imc())),
      },
      {
        'titulo': 'Nutrición',
        'imagenFondo': 'assets/nutricion.jpg',
        'accion': () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Nutricion())),
      },
      {
        'titulo': 'Ubicación',
        'imagenFondo': 'assets/ubicacion.jpg',
        'accion': () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CentrosGimnasio())),
      },
      {
        'titulo': 'Redes Sociales',
        'imagenFondo': 'assets/redesSociales.jpg',
        'accion': () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RedesSociales())),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: ListView.builder(
        itemCount: secciones.length,
        itemBuilder: (context, index) {
          var seccion = secciones[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              onTap: seccion['accion'],
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(seccion['imagenFondo']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        seccion['titulo'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
