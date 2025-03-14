import '/pages/onboardingCurso.dart';
import 'package:flutter/material.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({Key? key}) : super(key: key);

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController nameController = TextEditingController();
  int _currentStep = 1; // Define a etapa atual
  final int _totalSteps = 6; // Define o total de etapas

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
            // Ação ao pressionar voltar
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Indicadores de progresso
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalSteps,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: index + 1 < _currentStep
                        ? const Color(0xFF5271FF)// Bolinhas completadas
                        : index + 1 == _currentStep
                            ? Colors.blue.withOpacity(0.5) // Bolinha atual
                            : Colors.grey.shade300, // Bolinhas futuras
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Image.asset(
              'assets/images/homemComNotebook.png',
              height: 150,
            ),
            const SizedBox(height: 24),
            const Text(
              'Qual seu nome?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_currentStep > 1) _currentStep--;
                    });
                  },
                  child: const Text(
                    'Pular',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5271FF),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                     // if (_currentStep < _totalSteps) _currentStep++;

                    Navigator.push(context,
                   MaterialPageRoute(
                builder: (context) => const OnboardingCurso(),
                ),
                );

                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5271FF),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
