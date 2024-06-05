import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RedesSociales extends StatelessWidget {
  final Map<String, Map<String, String>> redes = {
    'Facebook': {
      'url': 'https://facebook.com',
      'imagenFondo': 'assets/facebook.jpg',
    },
    'Twitter': {
      'url': 'https://twitter.com',
      'imagenFondo': 'assets/twitter.jpg',
    },
    'Instagram': {
      'url': 'https://instagram.com',
      'imagenFondo': 'assets/instagram.jpg',
    },
  };

  RedesSociales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redes Sociales'),
      ),
      body: ListView.builder(
        itemCount: redes.length,
        itemBuilder: (context, index) {
          var red = redes.entries.elementAt(index);
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              onTap: () => _launchURL(Uri.parse(red.value['url']!)),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(red.value['imagenFondo']!),
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
                        red.key,
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

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
