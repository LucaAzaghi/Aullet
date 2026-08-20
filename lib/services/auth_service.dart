import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  //! registra un nuovo utente tramite email-password
  Future<AuthResponse> signUp ({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signUp(email: email, password: password);
  }

  //! esegue login attraverso l'email-password
  Future<AuthResponse> signIn ({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  //! eseguo il logout
  Future<void> signOut() {
    return _supabase.auth.signOut();
  }

  //! restituisce l'utente loggato, o null
  User? get currentUser => _supabase.auth.currentUser;
}