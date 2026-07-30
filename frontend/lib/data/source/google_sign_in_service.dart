import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles the Google OAuth popup / native flow and returns an ID token.
class GoogleSignInService {
  GoogleSignInService({required String? webClientId}) : _webClientId = webClientId;

  final String? _webClientId;
  bool _initialized = false;

  bool get isConfigured =>
      !kIsWeb || (_webClientId != null && _webClientId.isNotEmpty);

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    await GoogleSignIn.instance.initialize(
      clientId: kIsWeb ? _webClientId : null,
    );
    _initialized = true;
  }

  Future<String?> signInAndGetIdToken() async {
    if (!isConfigured) {
      throw StateError('Google web client ID is not configured');
    }

    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();

    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Google did not return an ID token');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!_initialized) {
      return;
    }
    await GoogleSignIn.instance.signOut();
  }
}
