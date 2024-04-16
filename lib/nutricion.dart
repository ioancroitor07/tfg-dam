import 'package:flutter/material.dart';

import 'DietaDetalle.dart';

class Nutricion extends StatelessWidget {
  const Nutricion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrición'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            tarjetaDieta(
              titulo: 'Definir',
              accion: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DietaDetalle(tituloDieta: 'Definir'),
                  ),
                );
              },
            ),
            tarjetaDieta(
              titulo: 'Adelgazar',
              accion: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DietaDetalle(tituloDieta: 'Adelgazar'),
                  ),
                );
              },
            ),
            tarjetaDieta(
              titulo: 'Aumentar Masa Muscular',
              accion: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DietaDetalle(tituloDieta: 'Adelgazar'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tarjetaDieta({required String titulo, required VoidCallback accion}) {
    return Card(
      child: InkWell(
        onTap: accion,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
