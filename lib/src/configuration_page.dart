import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configuración',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ConfigurationPage(),
    );
  }
}

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  bool _isDarkMode = false;

  // Método para cerrar sesión
  void _logout() {
    // Mostrar un cuadro de diálogo para confirmar el cierre de sesión
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Aquí pondrías la lógica para cerrar sesión
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Has cerrado sesión')),
                );
                // Simula una navegación de cierre de sesión (como regresar a la pantalla de inicio de sesión)
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
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
          // Opción Preferencias
          _buildSettingTile(
            title: 'Preferencias',
            subtitle: 'Tema, Notificaciones, General',
            icon: Icons.settings,
            onTap: () {
              _showInfoDialog('Preferencias', 'Aquí puedes configurar tus preferencias generales.');
            },
          ),
          const SizedBox(height: 16),
          
          // Opción Cuenta
          _buildSettingTile(
            title: 'Cuenta',
            subtitle: 'Perfil, Contraseña, Seguridad',
            icon: Icons.person,
            onTap: () {
              _showInfoDialog('Cuenta', 'Administra tu perfil, contraseña y seguridad.');
            },
          ),
          const SizedBox(height: 16),
          
          // Opción Privacidad
          _buildSettingTile(
            title: 'Privacidad',
            subtitle: 'Permisos, Datos',
            icon: Icons.lock,
            onTap: () {
              _showInfoDialog('Privacidad', 'Ajusta permisos y el uso de tus datos.');
            },
          ),
          const SizedBox(height: 16),
          
          // Opción Acerca de
          _buildSettingTile(
            title: 'Acerca de',
            subtitle: 'Versión de la App, Términos, Licencias',
            icon: Icons.info,
            onTap: () {
              _showInfoDialog('Acerca de', 'Versión 1.0.0\nTérminos y licencias disponibles aquí.');
            },
          ),
          const SizedBox(height: 16),
          
          // Botón de Cerrar sesión
          _buildSettingTile(
            title: 'Cerrar sesión',
            subtitle: 'Cerrar sesión de la aplicación',
            icon: Icons.exit_to_app,
            onTap: _logout,  // Aquí está la función para cerrar sesión con confirmación
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
