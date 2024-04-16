// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DietaDetalle extends StatelessWidget {
  final String tituloDieta;
  const DietaDetalle({Key? key, required this.tituloDieta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String contenidoDieta = obtenerContenidoDieta(tituloDieta);
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloDieta),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(contenidoDieta),
        ),
      ),
    );
  }

  String obtenerContenidoDieta(String dieta) {
    switch (dieta) {
      case 'Adelgazar':
        return 'Contenido de la dieta para adelgazar...'; 
      case 'Definir':
        return 'Contenido de la dieta para definir...'; 
      case 'Aumentar Masa Muscular':
        return 'Contenido de la dieta para aumentar masa muscular...'; 
      default:
        return 'Dieta no encontrada.';
    }
  }
}
