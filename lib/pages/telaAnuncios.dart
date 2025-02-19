import 'package:bitshare/pages/componentes/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'telaExibirAnuncio.dart'; // Importe a tela de exibição do anúncio

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
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: PesquisaProdutos());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Barra de pesquisa
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
                  hintText: "Pesquisar produtos",
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
                      final anuncioId = produto.id; // ID do documento
                      final anuncio = produto.data() as Map<String, dynamic>; // Dados do anúncio

                      return ListTile(
                        leading: Image.network(
                          anuncio['imagem'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 50);
                          },
                        ),
                        title: Text(anuncio['titulo']),
                        subtitle: Text("R\$${anuncio['preco']}"),
                        onTap: () {
                          // Navegar para a tela de detalhes do anúncio
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

// Classe para pesquisa no AppBar
class PesquisaProdutos extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = "")];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('anuncios').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final resultados = snapshot.data!.docs.where((doc) {
          final titulo = doc['titulo'].toString().toLowerCase();
          return titulo.contains(query.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: resultados.length,
          itemBuilder: (context, index) {
            final produto = resultados[index];
            final anuncioId = produto.id; // ID do documento
            final anuncio = produto.data() as Map<String, dynamic>; // Dados do anúncio

            return ListTile(
              title: Text(anuncio['titulo']),
              subtitle: Text("R\$${anuncio['preco']}"),
              onTap: () {
                // Navegar para a tela de detalhes do anúncio
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}