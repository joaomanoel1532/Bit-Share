import 'package:flutter/material.dart';
import '../telaHome.dart';
import '../telaCriarAnuncio.dart';
import '../TelaAnuncios.dart';
import '../telaPedidosFeitos.dart';

class BaseScreen extends StatefulWidget {
  final int selectedIndex;
  final Widget child;

  const BaseScreen({Key? key, required this.selectedIndex, required this.child}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  void _onItemTapped(int index) {
    if (index == widget.selectedIndex) return; // Evita navegação desnecessária

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const TelaCriarAnuncio();
        break;
      case 2:
        destination = PedidosScreen();
        break;
      case 3:
        destination = TelaProdutos();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        backgroundColor: Colors.white,
        elevation: 10,
        selectedItemColor: const Color(0xFFEE7124),
        unselectedItemColor: const Color(0xff5271FF),
        onTap: _onItemTapped,
        selectedLabelStyle: 
        const TextStyle(fontSize: 12, color: Color(0xFFEE7124)),
        unselectedLabelStyle:
        const TextStyle(fontSize: 12, color: Color(0xff5271FF)),
         showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Anunciar'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Produtos'),
        ],
      ),
    );
  }
}
