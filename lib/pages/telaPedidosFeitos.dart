import 'package:bitshare/pages/componentes/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PedidosScreen extends StatefulWidget {
  @override
  _PedidosScreenState createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getPedidos() async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return [];

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    List<dynamic> pedidos = userDoc['pedidos'] ?? [];

    return List<Map<String, dynamic>>.from(pedidos);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(selectedIndex: 2, child: 
    Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getPedidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Você ainda não fez nenhum pedido."));
          }
          List<Map<String, dynamic>> pedidos = snapshot.data!;
          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              var pedido = pedidos[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(pedido['titulo'] ?? 'Produto sem título'),
                  subtitle: Text("Preço: R\$${pedido['preco'].toString()}"),
                  trailing: Text(
                    pedido['status'] ?? 'Pendente',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              );
            },
          );
        },
      ),
    )
    );
  }
}
