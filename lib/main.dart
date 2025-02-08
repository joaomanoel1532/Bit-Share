import 'package:flutter/material.dart';
import './pages/telaLogin.dart'; // Importe a tela de login
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  print('Inicializando Firebase...');
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja inicializado
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase inicializado!');
  runApp(const MyApp()); // Inicia o aplicativo
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Meu App', 
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: LoginPage(),
    );
  }
}