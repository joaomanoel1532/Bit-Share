import 'dart:io';
import 'package:bitshare/pages/componentes/navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/services/auth_service.dart'; 

class TelaCriarAnuncio extends StatefulWidget {
  const TelaCriarAnuncio({super.key});

  @override
  _TelaCriarAnuncioState createState() => _TelaCriarAnuncioState();
}

class _TelaCriarAnuncioState extends State<TelaCriarAnuncio> {
  File? _image;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  String? _categoriaSelecionada;
  bool _isLoading = false;
  int _selectedIndex = 1;

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _salvarAnuncio() async {
    final user = AuthService().currentUser;
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    String preco = _precoController.text;
    if (user == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para criar um anúncio!')),
      );
    }

    if (titulo.isEmpty || descricao.isEmpty || preco.isEmpty || _categoriaSelecionada == null || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? errorMessage = await AuthService().salvarAnuncio(
      titulo: titulo,
      descricao: descricao,
      preco: preco,
      categoria: _categoriaSelecionada!,
      imageFile: _image!,
    );

    setState(() => _isLoading = false);

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anúncio salvo com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(selectedIndex: 1, child: 
    Scaffold(
      appBar: AppBar(
        title: const Text('Criar Anúncio'),
        backgroundColor: const Color(0xff5271FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selecionarImagem,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? const Center(child: Text('Clique para adicionar uma imagem'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(controller: _tituloController, label: 'Título do Produto'),
            const SizedBox(height: 10),
            _buildTextField(controller: _descricaoController, label: 'Descrição', maxLines: 3),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              items: ['Códigos', 'Componentes', 'Computador', 'Lista de exercício' , 'Livros' , 'Periféricos']
                  .map((String categoria) => DropdownMenuItem(value: categoria, child: Text(categoria)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSelecionada = value;
                });
              },
              decoration: _inputDecoration('Categoria'),
            ),
            const SizedBox(height: 10),
            _buildTextField(controller: _precoController, label: 'Preço (R\$)', keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _salvarAnuncio,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff5271FF),
                foregroundColor: Colors.black, // Define a cor do texto como preto
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator() 
                  : const Text(
                      'Anunciar', 
                      style: TextStyle(color: Colors.black), // Cor do texto preta
                    ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(controller: controller, maxLines: maxLines, keyboardType: keyboardType, decoration: _inputDecoration(label));
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
  }
}
