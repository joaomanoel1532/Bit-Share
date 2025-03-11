import 'package:bitshare/pages/componentes/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'telaExibirAnuncio.dart'; 

class TelaProdutos extends StatefulWidget {
  @override
  _TelaProdutosState createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  String _categoriaSelecionada = "Todos";
  String _pesquisa = "";
  final TextEditingController _pesquisaController = TextEditingController();

  Stream<QuerySnapshot> _buscarAnuncios() {
    Query query = FirebaseFirestore.instance.collection('anuncios');

    if (_categoriaSelecionada != "Todos") {
      query = query.where('categoria', isEqualTo: _categoriaSelecionada);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Produtos"),
        ),
        body: Column(
          children: [
            // Barra de pesquisa única
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _pesquisaController,
                onChanged: (value) {
                  setState(() {
                    _pesquisa = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Pesquise produtos",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            // Dropdown de categorias
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                value: _categoriaSelecionada,
                isExpanded: true,
                items: ["Todos", "Eletrônicos", "Livros", "Componentes", "Acessórios"]
                    .map((categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSelecionada = value!;
                  });
                },
              ),
            ),
            // Lista de produtos
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _buscarAnuncios(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Nenhum produto encontrado."));
                  }

                  final produtos = snapshot.data!.docs.where((doc) {
                    final titulo = doc['titulo'].toString().toLowerCase();
                    return titulo.contains(_pesquisa.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final produto = produtos[index];
                      final anuncioId = produto.id;
                      final anuncio = produto.data() as Map<String, dynamic>;

                      // Tratando o campo de fotos
                      final dynamic fotosField = anuncio['imagem'];
                      final List<String> fotos = fotosField is String
                          ? [fotosField]
                          : (fotosField as List<dynamic>).map((foto) => foto.toString()).toList();
                      final String? imagemUrl = fotos.isNotEmpty ? fotos.first : null;

                      return ListTile(
                        leading: imagemUrl != null
                            ? Image.network(
                                imagemUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 50);
                                },
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(anuncio['titulo']),
                        subtitle: Text("R\$${anuncio['preco']}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaExibicaoAnuncio(
                                anuncio: anuncio,
                                anuncioId: anuncioId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
