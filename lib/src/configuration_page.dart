import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  bool _isDarkMode = false;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Has cerrado sesión')),
                );
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _showInfoDialog(
      'Tema',
      _isDarkMode ? 'Has activado el tema oscuro.' : 'Has activado el tema claro.',
    );
  }

  void _showInfoDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showAccountInfo() {
    if (currentUser == null) {
      _showInfoDialog('Cuenta', 'No hay usuario logueado actualmente.');
      return;
    }

    String displayName = currentUser!.displayName ?? 'Nombre no disponible';
    List<String> parts = displayName.split(' ');
    String firstName = parts.isNotEmpty ? parts[0] : '';
    String lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    String email = currentUser!.email ?? 'Correo no disponible';
    String uid = currentUser!.uid;

    String info = 'Nombre: $firstName\n'
                  'Apellido: $lastName\n'
                  'Correo: $email\n'
                  'UID: $uid';

    _showInfoDialog('Cuenta', info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildSettingTile(
            title: 'Cuenta',
            subtitle: 'Perfil, Contraseña, Seguridad',
            icon: Icons.person,
            onTap: _showAccountInfo,
          ),
          const SizedBox(height: 16),

          _buildSettingTile(
            title: 'Acerca de',
            subtitle: 'Versión de la App, Términos, Licencias',
            icon: Icons.info,
            onTap: () {
              _showInfoDialog('Acerca de', 'Versión 1.0.0\nTérminos y licencias disponibles aquí.');
            },
          ),
          const SizedBox(height: 16),

          _buildSettingTile(
            title: 'Cerrar sesión',
            subtitle: 'Cerrar sesión de la aplicación',
            icon: Icons.exit_to_app,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
