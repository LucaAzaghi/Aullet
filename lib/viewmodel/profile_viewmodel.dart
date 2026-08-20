import 'package:aullet/models/profile.dart';
import 'package:aullet/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewmodel extends ChangeNotifier {
  final _repo = ProfileRepository();
  Profile? _profile;
  bool _isLoading = false;
  String? _error;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    _error = null;
    try {
      final user = Supabase.instance.client.auth.currentUser!;
      _profile = await _repo.fetchProfile(user.id);
      if (_profile == null) {
        _profile = Profile(
          id: '',
          userId: user.id,
          displayName: user.email!.split('@')[0],
        );
        await _repo.createProfile(_profile!);
        _profile = await _repo.fetchProfile(user.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateDisplayName(String newName) async {
    if (_profile == null) return;
    _setLoading(true);
    _error = null;
    try {
      _profile!.displayName = newName;
      await _repo.updateProfile(_profile!);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickAndUploadAvatar() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 75,
      );

      if (image == null) return;

      _setLoading(true);
      _error = null;

      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final fileName =
          '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: 'image/$fileExt',
            ),
          );

      final imageUrl = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(fileName);

      _profile!.avatarUrl = imageUrl;
      await _repo.updateProfile(_profile!);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
