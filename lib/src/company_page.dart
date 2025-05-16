import 'package:flutter/material.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GameZone Studios',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.white),
            onPressed: () {
              _mostrarDialogoConfiguracionEmpresa(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade50.withOpacity(0.1),
              Colors.deepPurple.shade100.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: ListView(
            children: [
              const Text(
                '¡Bienvenido a GameZone Studios!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              _buildCompanyCard(context),
              const SizedBox(height: 25),
              const Text(
                'Nuestros Equipos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              _buildTeamsSection(context),
              const SizedBox(height: 25),
              _buildContactUsSection(context),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCompanyCard(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.videogame_asset, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GameZone Studios',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nos especializamos en desarrollar videojuegos y experiencias innovadoras.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsSection(BuildContext context) {
    return Column(
      children: [
        _buildTeamCard(context, 'Desarrollo de Juegos', Icons.computer),
        const SizedBox(height: 16),
        _buildTeamCard(context, 'Arte y Diseño', Icons.brush),
        const SizedBox(height: 16),
        _buildTeamCard(context, 'Sonido y Música', Icons.music_note),
        const SizedBox(height: 16),
        _buildTeamCard(context, 'Control de Calidad', Icons.check_circle),
        const SizedBox(height: 16),
        _buildTeamCard(context, 'Marketing y Ventas', Icons.sell),
      ],
    );
  }

  Widget _buildTeamCard(BuildContext context, String titulo, IconData icono) {
    return InkWell(
      onTap: () {
        _mostrarDialogoEquipo(context, titulo);
      },
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
            Icon(icono, color: Colors.deepPurple, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContactUsSection(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contáctanos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Si deseas hablar sobre proyectos o colaboraciones, ¡escríbenos!',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _mostrarDialogoInfoContacto(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
              ),
              child: const Text(
                'Contactar ahora',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoConfiguracionEmpresa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Configuración de la Empresa', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Aquí puedes configurar los detalles de la empresa.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEquipo(BuildContext context, String nombreEquipo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de $nombreEquipo', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Aquí puedes ver los detalles del equipo de $nombreEquipo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _mostrarDialogoDetallesEquipo(context, nombreEquipo);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ver Detalles'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoDetallesEquipo(BuildContext context, String nombreEquipo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Información detallada - $nombreEquipo', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detalles completos del equipo de $nombreEquipo:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple.shade700)),
                const SizedBox(height: 10),
                if (nombreEquipo == 'Desarrollo de Juegos') ...[
                  const Text('• Desarrollo de motores de juego y programación de gameplay.'),
                  const Text('• Uso de tecnologías Unity y Unreal Engine.'),
                  const Text('• Colaboración con otros equipos para implementar características.'),
                ] else if (nombreEquipo == 'Arte y Diseño') ...[
                  const Text('• Diseño gráfico y modelado 3D.'),
                  const Text('• Creación de texturas y animaciones.'),
                  const Text('• Uso de herramientas como Blender y Photoshop.'),
                ] else if (nombreEquipo == 'Sonido y Música') ...[
                  const Text('• Composición de música original y efectos de sonido.'),
                  const Text('• Edición y mezcla de audio.'),
                  const Text('• Uso de software como Pro Tools y FL Studio.'),
                ] else if (nombreEquipo == 'Control de Calidad') ...[
                  const Text('• Pruebas exhaustivas para detectar bugs.'),
                  const Text('• Automatización de tests y documentación de errores.'),
                  const Text('• Coordinación con desarrollo para mejoras.'),
                ] else if (nombreEquipo == 'Marketing y Ventas') ...[
                  const Text('• Estrategias de marketing digital y redes sociales.'),
                  const Text('• Gestión de campañas publicitarias.'),
                  const Text('• Análisis de mercado y feedback de usuarios.'),
                ] else ...[
                  const Text('No hay información detallada disponible.'),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoInfoContacto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Información de Contacto',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('📞 Teléfono: +1 555 123 4567'),
                SizedBox(height: 6),
                Text('📧 Correo: contacto@gamezone.com'),
                SizedBox(height: 6),
                Text('🌐 Sitio Web: www.gamezone.com'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}