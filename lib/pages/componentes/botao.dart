import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  const Botao({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  final String texto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5271FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(200, 50),
        maximumSize: const Size(296, 50),
      ),
      onPressed: onPressed,
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
      ),
    );
  }
}