import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getAnuncios() {
    return _firestore.collection('anuncios').where('disponivel', isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot> _getListaDesejos() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore.collection('users').doc(user.uid).collection('lista_desejos').snapshots();
  }

  Future<List<String>> _getCategoriasUsuario() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return List<String>.from(doc.data()?['buscando'] ?? []);
  }

  int _selectedIndex = 0;
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Adicione a navegação para outras telas aqui
  }
  Widget _buildCategoryButton(String categoria) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: const Color(0xFF5271FF), // Cor azul específica
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        // Ação ao clicar na categoria (se precisar adicionar navegação, pode colocar aqui)
      },
      child: Text(categoria, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text('Home', style: TextStyle(color: Color(0xFF5271FF))),
        iconTheme: const IconThemeData(color: Color(0xFF5271FF)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar produtos",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // Produtos em destaque
            const Text("Produtos em destaque", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: _getAnuncios(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final anuncios = snapshot.data!.docs;
                if (anuncios.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Ainda não há anúncios cadastrados.", textAlign: TextAlign.center),
                  );
                }
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: anuncios.length,
                    itemBuilder: (context, index) {
                      final anuncio = anuncios[index].data() as Map<String, dynamic>;
                      return _buildProductCard(anuncio);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Lista de desejos
            const Text("Lista de desejos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: _getListaDesejos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final desejos = snapshot.data!.docs;
                if (desejos.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sua lista de desejos está vazia.", textAlign: TextAlign.center),
                  );
                }
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: desejos.length,
                    itemBuilder: (context, index) {
                      final desejo = desejos[index].data() as Map<String, dynamic>;
                      return _buildProductCard(desejo);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Categorias
            const Text("Categorias", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            FutureBuilder<List<String>>(
              future: _getCategoriasUsuario(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final categorias = snapshot.data!;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: categorias.map((categoria) => _buildCategoryButton(categoria)).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        selectedItemColor: const Color(0xFFEE7124),
        unselectedItemColor: const Color(0xff5271FF),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(
          fontSize: 12, 
          color: Color(0xFFEE7124)),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12, 
          color: Color(0xff5271FF)),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Anunciar"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Pedidos"),
          BottomNavigationBarItem(icon: Icon(Icons.verified), label: "Anúncios"),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> produto) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              produto['fotos'] != null && produto['fotos'].isNotEmpty ? produto['fotos'][0] : "https://via.placeholder.com/100",
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            produto['titulo'] ?? "Produto",
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
