import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RedesSociales extends StatelessWidget {
  final Map<String, String> redes = {
    'Facebook': 'https://facebook.com',
    'Twitter': 'https://twitter.com',
    'Instagram': 'https://instagram.com',
  };

  // ignore: use_key_in_widget_constructors
  RedesSociales({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redes Sociales'),
      ),
      body: ListView.separated(
        itemCount: redes.length,
        separatorBuilder: (context, index) => const Divider(), // Agrega un divisor entre cada elemento
        itemBuilder: (context, index) {
          String key = redes.keys.elementAt(index);
          String imagen = ''; // Ruta de la imagen de la red social
          if (key == 'Facebook') {
            imagen = 'assets/facebook.jpg';
          } else if (key == 'Twitter') {
            imagen = 'assets/twitter.jpg';
          } else if (key == 'Instagram') {
            imagen = 'assets/instagram.jpg';
          }
          return ListTile(
            leading: Image.asset(
              imagen,
              width: 48, // Tamaño de la imagen
              height: 48,
            ),
            title: Text(key),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _launchURL(Uri.parse(redes[key]!)),
          );
        },
      ),
    );
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
