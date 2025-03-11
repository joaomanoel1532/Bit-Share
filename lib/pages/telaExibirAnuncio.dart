import 'package:flutter/material.dart';
import 'componentes/botao.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaExibicaoAnuncio extends StatelessWidget {
  final Map<String, dynamic> anuncio;
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var anuncioId;
  TelaExibicaoAnuncio({super.key, required this.anuncio, required this.anuncioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        title: const Text('Anúncio', style: TextStyle(color: Color(0xFF5271FF))),
        backgroundColor: const Color(0xffFAFAFA),
        iconTheme: const IconThemeData(color: Color(0xFF5271FF)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                anuncio['imagem'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              anuncio['titulo'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              anuncio['descricao'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${anuncio['preco'].toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 20),
            Botao(texto: 'Adicionar a lista de desejos', onPressed: () async{
              final user = _auth.currentUser;
              if (user != null){
                await _authService.salvarListaDesejos(user!.uid, anuncioId);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Adicionado à lista de desejos!')
                ),
                );
              }
            },
            ),
            const SizedBox(height: 10),
            Botao(texto: "Comprar agora!", onPressed: () async{
              
            })
          ],
        ),
      ),
    );
  }
}
