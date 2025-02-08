import 'package:flutter/material.dart';
import '../services/auth_service.dart'; 
import 'telaLogin.dart';
import 'componentes/botao.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  RegisterPage({super.key});

  // Função para validar o nome
  bool _validateNome(String nome) {
    return RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(nome);
  }

  // Função para validar o e-mail
  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: const Color(0xFFFAFAFA),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xff5271FF)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.1),
                    Color.fromRGBO(0, 0, 0, 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/Logo.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: const TextStyle(color: Color(0xff5271FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff5271FF)),
                  ),
                  errorText: _nomeController.text.isNotEmpty && !_validateNome(_nomeController.text)
                      ? 'Nome inválido (não use números ou caracteres especiais)'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0xff5271FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff5271FF)),
                  ),
                  errorText: _emailController.text.isNotEmpty && !_validateEmail(_emailController.text)
                      ? 'E-mail inválido'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: Color(0xff5271FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff5271FF)),
                  ),
                  errorText: _passwordController.text.isNotEmpty && _passwordController.text.length < 8
                      ? 'A senha deve ter no mínimo 8 caracteres'
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  labelStyle: const TextStyle(color: Color(0xff5271FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xff5271FF)),
                  ),
                  errorText: _confirmPasswordController.text.isNotEmpty &&
                          _passwordController.text != _confirmPasswordController.text
                      ? 'As senhas não coincidem'
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              Botao(
                texto: 'Cadastrar', 
                onPressed: () async {
                  String nome = _nomeController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String confirmPassword = _confirmPasswordController.text.trim();

                  // Validações
                  if (nome.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos.')),
                    );
                    return;
                  }

                  if (!_validateNome(nome)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nome inválido.')),
                    );
                    return;
                  }

                  if (!_validateEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('E-mail inválido.')),
                    );
                    return;
                  }

                  if (password.length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('A senha deve ter no mínimo 8 caracteres.')),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('As senhas não coincidem.')),
                    );
                    return;
                  }

                  // Tenta cadastrar o usuário
                  String? errorMessage = (await _authService.registerWithEmailAndPassword(email, password, nome)) as String?;

                  if (errorMessage != null) {
                    // Exibe a mensagem de erro
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  } else {
                    // Cadastro bem-sucedido
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já possui uma conta?',
                    style: TextStyle(color: Color(0xff5271FF)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xff5271FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}