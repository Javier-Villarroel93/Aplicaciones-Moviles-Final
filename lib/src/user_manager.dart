import 'package:flutter/material.dart';

class UserManager extends ChangeNotifier {
  // Singleton
  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  // Lista para almacenar usuarios, en un escenario real sería una base de datos
  final List<Map<String, String>> _users = [];

  // Variable para saber si un usuario está autenticado
  String? _currentUserEmail;

  // Obtiene el estado de autenticación del usuario
  bool get isAuthenticated => _currentUserEmail != null;

  // Obtiene el correo del usuario autenticado
  String? get currentUserEmail => _currentUserEmail;

  // Registrar un nuevo usuario
  void registerUser(String email, String password) {
    if (!emailExists(email)) {
      _users.add({'email': email, 'password': password});
      notifyListeners(); // Notificar a los oyentes de que el usuario se registró
    } else {
      throw Exception('El correo ya está registrado');
    }
  }

  // Validar un usuario con el correo y la contraseña
  bool validateUser(String email, String password) {
    final validUser = _users.any((user) =>
        user['email'] == email && user['password'] == password);
    if (validUser) {
      _currentUserEmail = email;
      notifyListeners(); // Notificar que el usuario ha iniciado sesión
    }
    return validUser;
  }

  // Comprobar si un correo ya está registrado
  bool emailExists(String email) {
    return _users.any((user) => user['email'] == email);
  }

  // Iniciar sesión
  bool logIn(String email, String password) {
    if (validateUser(email, password)) {
      _currentUserEmail = email;
      notifyListeners(); // Notificar que el usuario está autenticado
      return true;
    }
    return false;
  }

  // Cerrar sesión
  void logOut() {
    _currentUserEmail = null;
    notifyListeners(); // Notificar que el usuario ha cerrado sesión
  }
}
