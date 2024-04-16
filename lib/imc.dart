import 'package:flutter/material.dart';

class Imc extends StatefulWidget {
  const Imc({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImcState createState() => _ImcState();
}

class _ImcState extends State<Imc> {
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  String _resultado = '';

  void calcularIMC() {
    final double peso = double.tryParse(_pesoController.text) ?? 0;
    final double alturaCm = double.tryParse(_alturaController.text) ?? 0;
    final double alturaMetros = alturaCm / 100;

    if (peso > 0 && alturaCm > 0) {
      final double imc = peso / (alturaMetros * alturaMetros);
      String categoria;
      if (imc < 18.5) {
        categoria = 'Bajo peso';
      } else if (imc >= 18.5 && imc < 24.9) {
        categoria = 'Adecuado';
      } else if (imc >= 25 && imc < 29.9) {
        categoria = 'Sobrepeso';
      } else if (imc >= 30 && imc < 34.9) {
        categoria = 'Obesidad grado 1';
      } else if (imc >= 35 && imc < 39.9) {
        categoria = 'Obesidad grado 2';
      } else {
        categoria = 'Obeso extremo';
      }
      setState(() {
        _resultado = 'Tu IMC es ${imc.toStringAsFixed(2)} ($categoria)';
      });
    } else {
      setState(() {
        _resultado = 'Por favor, introduce valores válidos para peso y altura.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: SingleChildScrollView(
        // Envuelve el contenido en un SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/imc2.jpg'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _alturaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Altura (cm)',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Peso (kg)',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: calcularIMC,
                child: const Text('Calcular IMC'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _resultado,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
