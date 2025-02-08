import './onboardingIES.dart';
import 'package:flutter/material.dart';


class OnboardingCurso extends StatefulWidget {
  const OnboardingCurso({Key? key}) : super(key: key);

  @override
  State<OnboardingCurso> createState() => _OnboardingCursoState();
}

class _OnboardingCursoState extends State<OnboardingCurso> {
  final TextEditingController nameController = TextEditingController();
  int _currentStep = 2; // Etapa atual
  final int _totalSteps = 6; // Total de etapas

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
              'assets/images/OnboardingCurso.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Qual seu curso?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Curso',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingIES(),
                      ),
                    );
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