import 'package:flutter/material.dart';

import 'EjercicioDetalle.dart';

class Ejercicios extends StatelessWidget {
  const Ejercicios({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          tarjetaEjercicio(
            titulo: 'Pecho',
            imagen: 'assets/pecho.jpg',
            accion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EjercicioDetalle(tituloEjercicio: 'Pecho'),
                ),
              );
            },
          ),
          tarjetaEjercicio(
            titulo: 'Pierna',
            imagen: 'assets/pierna.jpg',
            accion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EjercicioDetalle(tituloEjercicio: 'Pierna'),
                ),
              );
            },
          ),
          tarjetaEjercicio(
            titulo: 'Bíceps',
            imagen: 'assets/biceps.jpg',
            accion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EjercicioDetalle(tituloEjercicio: 'Biceps'),
                ),
              );
            },
          ),
          tarjetaEjercicio(
            titulo: 'Tríceps',
            imagen: 'assets/triceps.jpg',
            accion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EjercicioDetalle(tituloEjercicio: 'Triceps'),
                ),
              );
            },
          ),
          tarjetaEjercicio(
            titulo: 'Espalda',
            imagen: 'assets/espalda.jpg',
            accion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EjercicioDetalle(tituloEjercicio: 'Espalda'),
                ),
              );
            },
          ),
          tarjetaEjercicio(
            titulo: 'Hombro',
            imagen: 'assets/hombro.jpg',
            accion: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const EjercicioDetalle(tituloEjercicio: 'Hombro'),
                ),
              );
            },
          ),
          // Agrega más tarjetas de ejercicios aquí según sea necesario
        ],
      ),
    );
  }

  Widget tarjetaEjercicio({
    required String titulo,
    required String imagen,
    required VoidCallback accion,
  }) {
    return Card(
      child: InkWell(
        onTap: accion,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagen),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
