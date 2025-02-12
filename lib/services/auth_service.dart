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
          'primeiroAcesso': true,
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
      if (userDoc.exists) {
        return userDoc['primeiroAcesso'] ?? true;
      } else {
        return true;
      }
   } catch (e) {
      print("Erro ao verificar primeiro acesso: $e");
    return true;
    }
  }
  Future<void> salvarRespostasOnboardingCurso(String userId, String curso) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'curso': curso,
      });
    } catch (e) {
      print("Erro ao salvar respostas do onboarding: $e");
    }
  }
  Future<void> salvarRespostasOnboardingInstituicao(String userId, String instituicao) async{
    try{
      await _firestore.collection('users').doc(userId).update({
        'instituicao': instituicao,
      });
    } catch (e) {
      print("Erro ao salvar respostas do onboarding: $e");
    }
  }
  Future<void> salvarRespostasOnboardingBuscando(String userId, List<String> buscando) async{
    try{
      await _firestore.collection('users').doc(userId).update({
        'buscando': buscando,
      });
    } catch (e) {
      print("Erro ao salvar respostas do onboarding: $e");
    }
  }
  Future<void> salvarRespostasOnboardingInteresses(String userId, List<String> interesses) async{
    try{
      await _firestore.collection('users').doc(userId).update({
        'interesses': interesses,
        'primeiroAcesso': false,
      });
    } catch (e) {
      print("Erro ao salvar respostas do onboarding: $e");
    }
  }


  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}