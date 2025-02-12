import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import './onboardingFinalizado.dart';

class OnboardingInteressesAcademicos extends StatefulWidget {
  const OnboardingInteressesAcademicos({Key? key}) : super(key: key);

  @override
  State<OnboardingInteressesAcademicos> createState() => _OnboardingInteressesAcademicos();
}

class _OnboardingInteressesAcademicos extends State<OnboardingInteressesAcademicos> {
  final AuthService _authService = AuthService();
  final Set<int> _selectedIndices = {};
  int _currentStep = 5;
  final int _totalSteps = 6;

  final List<String> options = [
    "Algoritmos",
    "Arquitetura de Computadores",
    "Banco de Dados",
    "Desenvolvimento de Software",
    "Desenvolvimento Mobile",
    "Desenvolvimento Web",
    "Engenharia de Software",
    "Estruturas de Dados",
    "Machine Learning",
    "Segurança de Dados",
    "Sistemas Operacionais",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalSteps,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: index + 1 < _currentStep
                        ? const Color(0xFF5271FF)
                        : index + 1 == _currentStep
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            Image.asset(
              'assets/images/OnboardingInteresses.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100);
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Selecione seus Interesses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndices.contains(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: isSelected ? Colors.blue[700] : Colors.blue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isSelected) {
                            _selectedIndices.remove(index);
                          } else {
                            _selectedIndices.add(index);
                          }
                        });
                      },
                      child: Text(
                        options[index],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Pular',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectedIndices.isNotEmpty ? _salvarEContinuar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5271FF),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvarEContinuar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<String> interessesSelecionados = _selectedIndices.map((i) => options[i]).toList();
      await _authService.salvarRespostasOnboardingInteresses(user.uid, interessesSelecionados);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingFinalizado()),
      );
    } else {
      print("Usuário não autenticado!");
    }
  }
}
