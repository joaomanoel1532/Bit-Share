import 'package:flutter/material.dart';
import './componentes/botao.dart';
import 'onboardingNome.dart';

class OnboardingScreenInitial extends StatelessWidget {
  const OnboardingScreenInitial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Vamos começar!',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bem-vindo(a) ao app!\nPara iniciar, vamos adicionar algumas informações sobre seu perfil.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/OnboardingInicial.png',
              height: 200,
            ),
            const SizedBox(height: 32),
            Botao(texto: 'Iniciar', onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => const NameInputScreen(),
                ),
              );

            },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Ação ao pressionar "Pular"
              },
              child: const Text(
                'Pular',
                style: TextStyle(fontSize: 16, color: Color(0xff5271FF), fontFamily: 'Inter',),
              ),
            ),
          ],
        ),
      ),
    );
  }
}