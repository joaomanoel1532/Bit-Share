import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'componentes/botao.dart';
import '../services/auth_service.dart';

class TelaExibicaoAnuncio extends StatefulWidget {
  final Map<String, dynamic> anuncio;
  final String anuncioId;

  const TelaExibicaoAnuncio({
    super.key,
    required this.anuncio,
    required this.anuncioId,
  });

  @override
  State<TelaExibicaoAnuncio> createState() => _TelaExibicaoAnuncioState();
}

class _TelaExibicaoAnuncioState extends State<TelaExibicaoAnuncio> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInWishList = false;

  @override
  void initState() {
    super.initState();
    _checkIfInWishList();
  }

  Future<void> _checkIfInWishList() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final listaDesejos = List<String>.from(doc.data()?['lista_desejos'] ?? []);
      setState(() {
        _isInWishList = listaDesejos.contains(widget.anuncioId);
      });
    }
  }

  Future<void> _addToWishList() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _authService.salvarListaDesejos(user.uid, widget.anuncioId);
      setState(() {
        _isInWishList = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicionado à lista de desejos!')),
      );
    }
  }

  Future<void> _removeFromWishList() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'lista_desejos': FieldValue.arrayRemove([widget.anuncioId])
      });
      setState(() {
        _isInWishList = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removido da lista de desejos!')),
      );
    }
  }

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
                widget.anuncio['imagem'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.anuncio['titulo'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.anuncio['descricao'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${widget.anuncio['preco'].toString()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Botão dinâmico para adicionar ou remover da lista de desejos
            _isInWishList
                ? ElevatedButton.icon(
                    onPressed: _removeFromWishList,
                    icon: const Icon(Icons.delete),
                    label: const Text('Remover da lista de desejos'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  )
                : Botao(
                    texto: 'Adicionar à lista de desejos',
                    onPressed: _addToWishList,
                  ),

            const SizedBox(height: 10),
            Botao(
              texto: "Comprar agora!",
              onPressed: () {
                // Implementar lógica de compra
              },
            ),
          ],
        ),
      ),
    );
  }
}
