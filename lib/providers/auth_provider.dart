import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userId;

  AuthState({this.isAuthenticated = false, this.userId});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String email, String password) async {
    // TODO: Implémenter la logique d'authentification
    state = AuthState(isAuthenticated: true, userId: 'temp_user');
    return true;
  }

  Future<bool> signup(
    String email,
    String name,
    String prenom,
    String password,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    // TODO: Implémenter l'inscription avec tous les paramètres
    state = AuthState(isAuthenticated: true, userId: 'temp_user');
    return true;
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
