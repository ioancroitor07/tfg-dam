import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'login.dart'; 
 
void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialización condicional de Firebase
  if (kIsWeb) {
    // Configuración específica de Firebase para la web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBy6U7IQ2s_AG6Bu7osvoOGQmSEP-b-1p0", 
        authDomain: "tfg-dam-ea7e5.firebaseapp.com", 
        projectId: "tfg-dam-ea7e5", 
        storageBucket: "tfg-dam-ea7e5.appspot.com", 
        messagingSenderId: "579030577248", 
        appId: "1:579030577248:web:92b38030029976a390d305", 
      ),
    );
  } else {
    // Configuración por defecto de Firebase para Android/iOS
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'GYM'), 
    );
  }
}
