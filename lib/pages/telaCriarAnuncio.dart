import 'package:flutter/material.dart';
import 'dart:io';

class telaCriarAnuncio extends StatefulWidget {
  const telaCriarAnuncio({super.key});

  @override
  telaCriarAnuncioState createState() => telaCriarAnuncioState();
}

class telaCriarAnuncioState extends State<telaCriarAnuncio> {
  File? _image;
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  String? categoriaSelecionada;

  // Função para salvar o anúncio
  void _salvarAnuncio() {
    String titulo = tituloController.text;
    String descricao = descricaoController.text;
    String preco = precoController.text;

    if (titulo.isEmpty || descricao.isEmpty || preco.isEmpty || categoriaSelecionada == null || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Simulação de envio
    print("Anúncio Salvo:\nTítulo: $titulo\nDescrição: $descricao\nCategoria: $categoriaSelecionada\nPreço: $preco\nImagem: ${_image!.path}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anúncio salvo com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Anúncio'),
        backgroundColor: const Color(0xff5271FF), // Cor alterada
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Botão para adicionar imagem
              GestureDetector(
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? const Center(child: Text('Clique para adicionar uma imagem'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),

              // Caixa de entrada para o título
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título do Produto',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Caixa de entrada para a descrição
              TextField(
                controller: descricaoController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Seleção de categoria
              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                items: ['Eletrônicos', 'Livros', 'Componentes', 'Acessórios']
                    .map((String categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoriaSelecionada = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Caixa de entrada para o preço
              TextField(
                controller: precoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Preço (R\$)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              // Botão de Anunciar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarAnuncio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5271FF), // Cor alterada
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Anunciar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
