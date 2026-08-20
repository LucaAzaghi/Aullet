import 'package:aullet/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _client = Supabase.instance.client;

  /// Restituisce il profilo dell'utente, o null se non esiste
  Future<Profile?> fetchProfile(String userId) async {
    final data = await _client 
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
        
    if (data == null) return null;
    
    // Rimosso il cast non necessario perché data è già compatibile
    return Profile.fromMap(data);
  }

  /// Inserisce un nuovo profilo
  Future<void> createProfile(Profile profile) async {
    await _client.from('profiles').insert(profile.toMap());
  }

  /// Aggiorna il profilo esistente
  Future<void> updateProfile(Profile profile) async {
    await _client
        .from('profiles')
        .update(profile.toMap())
        .eq('user_id', profile.userId);
  }
}