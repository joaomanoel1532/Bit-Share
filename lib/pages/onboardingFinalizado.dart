import 'package:flutter/material.dart';

class OnboardingFinalizado extends StatefulWidget {
  const OnboardingFinalizado({Key? key}) : super(key: key);

  @override
  State<OnboardingFinalizado> createState() => _OnboardingFinalizadoState();
}

class _OnboardingFinalizadoState extends State<OnboardingFinalizado> {
  final int _currentStep = 7; // Etapa final
  final int _totalSteps = 7; // Total de etapas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAFAFA),
        elevation: 0,
        automaticallyImplyLeading: false,
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
            const SizedBox(height: 16),

            // Indicadores de progresso
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalSteps,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: index + 1 <= _currentStep
                        ? const Color(0xFF5271FF)
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Imagem
            Image.asset(
              'assets/images/OnboardingFinalizado.png',
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100);
              },
            ),
            const SizedBox(height: 24),

            // Texto principal
            const Text(
              'Perfeito!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Subtexto
            const Text(
              'Aproveite o app, obtenha a melhor experiência, e contribua para o fortalecimento da colaboração e sustentabilidade na comunidade acadêmica.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Botão de Home
            ElevatedButton(
              onPressed: () {
                // Substituir por ação para ir para tela inicial
                Navigator.of(context).pushReplacementNamed('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5271FF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
             child: const Row(
                mainAxisSize: MainAxisSize.min, // Garante que o Row ocupe o tamanho mínimo necessário
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8), // Espaço entre o texto e o ícone
                  Icon(
                    Icons.arrow_forward, // Ícone da seta para frente
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}