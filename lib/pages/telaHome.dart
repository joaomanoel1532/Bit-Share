import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'telaExibirAnuncio.dart';
import 'componentes/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _pesquisa = "";
  final TextEditingController _pesquisaController = TextEditingController();
  List<Map<String, dynamic>> _recommendedProducts = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchRecommendedProducts();
  }

  Future<void> _fetchRecommendedProducts() async {
    final user = _auth.currentUser;

    if (user == null) {
      // Usuário não autenticado: recomendar produtos aleatórios
      List<Map<String, dynamic>> randomProducts = await _getRandomProducts();
      setState(() {
        _recommendedProducts = randomProducts;
        _isLoading = false;
      });
    } else {
      // Usuário autenticado: buscar categorias de interesse
      List<String> categorias = await _getCategoriasUsuario();

      List<Map<String, dynamic>> recommended =
          await _getProductsByCategories(categorias);

      if (recommended.isEmpty) {
        // Se não houver recomendações personalizadas, recomendar aleatoriamente
        recommended = await _getRandomProducts();
      }

      setState(() {
        _recommendedProducts = recommended;
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getProductsByCategories(
      List<String> categorias) async {
    try {
      if (categorias.isEmpty) return [];

      QuerySnapshot query = await _firestore
          .collection('anuncios')
          .where('categoria', whereIn: categorias)
          .where('disponivel', isEqualTo: true)
          .limit(10)
          .get();

      return query.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getRandomProducts() async {
    try {
      QuerySnapshot query = await _firestore
          .collection('anuncios')
          .where('disponivel', isEqualTo: true)
          .limit(10)
          .get();

      return query.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; 
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Stream<QuerySnapshot> _getAnuncios() {
  //   if (_pesquisa.isEmpty) {
  //     return _firestore.collection('anuncios').where('disponivel', isEqualTo: true).snapshots();
  //   } else {
  //     return _firestore
  //         .collection('anuncios')
  //         .where('titulo', isGreaterThanOrEqualTo: _pesquisa)
  //         .where('titulo', isLessThanOrEqualTo: '$_pesquisa\uf8ff')
  //         .snapshots();
  //   }
  // }

  Stream<List<Map<String, dynamic>>> _getListaDesejos() {
  final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore.collection('users').doc(user.uid).snapshots().asyncMap((docSnapshot) async {
      if (!docSnapshot.exists) return [];
      List<dynamic> listaDesejos = docSnapshot.data()?['lista_desejos'] ?? [];
      if (listaDesejos.isEmpty) return []; 
      List<Map<String, dynamic>> anuncios = [];

      for (var i = 0; i < listaDesejos.length; i += 10) {
        final batch = listaDesejos.sublist(i, i + 10 > listaDesejos.length ? listaDesejos.length : i + 10);
        final querySnapshot = await _firestore.collection('anuncios').where(FieldPath.documentId, whereIn: batch).get();

        anuncios.addAll(querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          data['id'] = doc.id;
          return data;
        }));
      }

      return anuncios;
    });
  }

  Future<List<String>> _getCategoriasUsuario() async {
    final user = _auth.currentUser;
    if (user == null) return [];
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return List<String>.from(doc.data()?['buscando'] ?? []);
  }

  Widget _buildCategoryButton(String categoria) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: const Color(0xFF5271FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        
      ),
      onPressed: () {
        
      },
      child: Text(categoria, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(selectedIndex: 0, child: 
    Scaffold(
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
              controller: _pesquisaController,
              onChanged: (value){
                setState(() {
                  _pesquisa = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: "Pesquisar produtos",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            // Recomendações personalizadas ou aleatórias
            const Text("Recomendações para você", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recommendedProducts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Nenhum produto encontrado.", textAlign: TextAlign.center),
                      )
                    : SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _recommendedProducts.length,
                          itemBuilder: (context, index) {
                            final produto = _recommendedProducts[index];
                            final anuncioId = produto['id'];
                            return _buildProductCard(produto, anuncioId);
                          },
                        ),
                      ),
            // const Text("Produtos em destaque", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // StreamBuilder<QuerySnapshot>(
            //   stream: _getAnuncios(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) return const CircularProgressIndicator();
            //     final anuncios = snapshot.data!.docs;
            //     if (anuncios.isEmpty) {
            //       return const Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child: Text("Nenhum produto encontrado.", textAlign: TextAlign.center),
            //       );
            //     }
            //     return SizedBox(
            //       height: 140,
            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: anuncios.length,
            //         itemBuilder: (context, index) {
            //           final anuncio = anuncios[index].data() as Map<String, dynamic>;
            //           final anuncioId = anuncios[index].id;
            //           return _buildProductCard(anuncio, anuncioId);
            //         },
            //       ),
            //     );
            //   },
            // ),
            const SizedBox(height: 20),
            const Text("Lista de Desejos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getListaDesejos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final desejos = snapshot.data!;
                if (desejos.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sua lista de desejos está vazia."),
                  );
                }
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: desejos.length,
                    itemBuilder: (context, index){
                      final produto = desejos[index];
                      return _buildProductCard(produto, produto['id']);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("Categorias", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            FutureBuilder<List<String>>(
              future: _getCategoriasUsuario(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final categorias = snapshot.data!;
                if (categorias.isEmpty) {
                  return const Text("Nenhuma categoria encontrada.");
                }
                return Wrap(
                  spacing: 8,
                  children: categorias.map((categoria) => _buildCategoryButton(categoria)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }


  Widget _buildProductCard(Map<String, dynamic> produto, String anuncioId) {
    final String imageUrl = produto['imagem'] ?? "https://via.placeholder.com/100";
    // Debug: Exibe a URL da imagem no console
    print("Carregando imagem: $imageUrl");

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (Context) => TelaExibicaoAnuncio(anuncio: produto, anuncioId: anuncioId)
            ));
      },
        child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Debug: Exibe o erro no console
                  print("Erro ao carregar imagem: $error");
                  return const Icon(Icons.image_not_supported, size: 100);
                },
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
      ),
    ); 
  }
}
