import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cadastrar usuário com email e senha
  Future<String?> registerWithEmailAndPassword(String email, String password, String nome) async {
    try {
      // Cria o usuário no Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Salva os dados do usuário no Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'nome': nome,
          'email': email,
          'curso': '',
          'instituicao': '',
          'buscando': [],
          'interesses': [],
          'lista_desejos': [],
        });
      }

      return null; // Retorna null se não houver erro
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro do Firebase Auth
    } on FirebaseException catch (e) {
      return e.message; // Retorna a mensagem de erro do Firestore
    } catch (e) {
      return "Ocorreu um erro ao cadastrar. Tente novamente."; // Erro genérico
    }
  }

  // Login com email e senha
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Retorna null se não houver erro
    } on FirebaseAuthException catch (e) {
      return e.message; // Retorna a mensagem de erro
    }
  }

  // Verificar se é o primeiro acesso
  Future<bool> isFirstAccess(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      return !userDoc.exists; // Se o documento não existir, é o primeiro acesso
    } catch (e) {
      print("Erro ao verificar primeiro acesso: $e");
      return true; // Assume que é o primeiro acesso em caso de erro
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}