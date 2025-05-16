import 'package:flutter/material.dart';
import 'package:menu/src/carrito_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Asegúrate de haber inicializado Firebase en tu main.dart o en algún punto anterior
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarritoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuPrincipal(),
      // Define tus rutas aquí si las estás utilizando
      // routes: {
      //   '/home': (context) => HomeScreen(),
      //   '/configuration': (context) => ConfigurationScreen(),
      //   '/company': (context) => CompanyScreen(),
      //   '/clases': (context) => TrailersScreen(),
      // },
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final User? user = FirebaseAuth.instance.currentUser;
    String? displayName = user?.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎮 Game Store',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          if (displayName != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  'Bienvenido, $displayName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple.shade900,
                Colors.deepPurple.shade800,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _AnimatedDrawerHeaderItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/dota1.webp'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      displayName ?? 'Invitado', // Muestra el nombre del usuario o "Invitado"
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?.email ?? 'No autenticado', // Muestra el email o un mensaje
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                route: null,
              ),
              _buildDrawerItem(context,
                  icon: Icons.home, text: 'Tienda', route: '/home'),
              _buildDrawerItem(context,
                  icon: Icons.settings, text: 'Configuración', route: '/configuration'),
              _buildDrawerItem(context,
                  icon: Icons.business, text: 'Empresa', route: '/company'),
              _buildDrawerItem(context,
                  icon: Icons.sports_esports, text: 'Trailers', route: '/clases'),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context); // Cierra el drawer
                  try {
                    await FirebaseAuth.instance.signOut();
                    // Aquí puedes navegar a la pantalla de inicio de sesión si lo deseas
                    // Navigator.pushReplacementNamed(context, '/login');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sesión cerrada correctamente.')),
                    );
                    // Actualiza la UI si es necesario para reflejar el estado de no autenticado
                    // Por ejemplo, podrías reconstruir el widget MenuPrincipal
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                      );
                    }
                  } catch (e) {
                    print('Error al cerrar sesión: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al cerrar sesión: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('🔥 Ofertas Destacadas'),
                _buildGameCarousel(context, screenWidth, 6, 'offer'),
                const SizedBox(height: 30),
                _buildSectionTitle('🆕 Nuevos Lanzamientos'),
                _buildGameCarousel(context, screenWidth, 6, 'new'),
                const SizedBox(height: 30),
                _buildSectionTitle('🚀 Próximamente'),
                _buildGameCarousel(context, screenWidth, 6, 'coming_soon'),
                const SizedBox(height: 30),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String route,
  }) {
    return _AnimatedDrawerItem(
      icon: icon,
      text: text,
      route: route,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  Widget _buildGameCarousel(
      BuildContext context, double screenWidth, int itemCount, String type) {
    List<String> imagePaths = [];
    List<String> gameNames = [];
    List<String> gameDescriptions = [];
    List<String> gameCategories = [];

    if (type == 'offer') {
      imagePaths = [
        'assets/images/ofter1.jpg',
        'assets/images/ofter2.jpg',
        'assets/images/ofter3.jpg',
        'assets/images/ofter4.jpg',
        'assets/images/ofter5.jpg',
        'assets/images/ofter6.jpg',
      ];
      gameNames = [
        'Days Gone (2019)',
        'Guardianes de la Galaxia (2021)',
        'Resident Evil 4 Remake (2023)',
        'God of War (2018)',
        'Resident Evil Village (2021)',
        'Bloodborne (2015)'
      ];
      gameDescriptions = [
        'Sobrevive en un mundo abierto infestado de infectados en esta aventura postapocalíptica.',
        'Únete a los Guardianes en una historia original llena de acción y humor.',
        'Revive el clásico en una versión moderna con gráficos mejorados y combate renovado.',
        'Embárcate en un viaje emocional junto a Kratos y Atreus por la mitología nórdica.',
        'Una historia de horror y supervivencia con gráficos de última generación.',
        'Explora Yharnam en esta aventura gótica llena de acción y misterio.'
      ];
      gameCategories = ['Aventura', 'Acción', 'Survival Horror', 'Hack and Slash', 'Terror', 'RPG'];
    } else if (type == 'new') {
      imagePaths = [
        'assets/images/new1.jpg',
        'assets/images/new2.jpg',
        'assets/images/new3.jpg',
        'assets/images/new4.jpg',
        'assets/images/new5.jpg',
        'assets/images/new6.jpg',
      ];
      gameNames = [
        'Uncharted 4 (2016)',
        'Call of Duty: Modern Warfare (2019)',
        'Battlefield 1 (2016)',
        'The Callisto Protocol (2022)',
        'Until Dawn (2015)',
        'Doom Eternal (2020)'
      ];
      gameDescriptions = [
        'Descubre el último tesoro con Nathan Drake en esta épica aventura narrativa.',
        'Acción táctica en un reboot oscuro y realista de la saga Modern Warfare.',
        'Vive la Primera Guerra Mundial con intensos combates multijugador.',
        'Un survival horror espacial con una ambientación aterradora.',
        'Tus decisiones determinan quién sobrevive en esta historia interactiva de horror.',
        'Destruye demonios con brutalidad en este shooter frenético y visceral.'
      ];
      gameCategories = ['Aventura', 'Shooter Táctico', 'FPS Histórico', 'Terror Espacial', 'Narrativo', 'Acción Rápida'];
    } else if (type == 'coming_soon') {
      imagePaths = [
        'assets/images/coming_soon1.jpg',
        'assets/images/coming_soon2.jpg',
        'assets/images/coming_soon3.jpg',
        'assets/images/coming_soon4.jpg',
        'assets/images/coming_soon5.jpg',
        'assets/images/coming_soon6.jpg',
      ];
      gameNames = [
        'Spider-Man (2018)',
        'Resident Evil 3 Remake (2020)',
        'Gran Turismo Sport (2017)',
        'Mortal Kombat X (2015)',
        'Grand Theft Auto V (2013)',
        'Horizon Forbidden West (2022)'
      ];
      gameDescriptions = [
        'Balancea por Nueva York en una historia original del superhéroe arácnido.',
        'Enfréntate al temido Némesis en esta intensa reimaginación de un clásico.',
        'Carreras realistas con cientos de autos y circuitos icónicos.',
        'Lucha brutal con nuevos personajes, fatalities épicos y mucha sangre.',
        'Explora Los Santos en uno de los sandbox más exitosos de la historia.',
        'Acompaña a Aloy en una nueva aventura por tierras desconocidas y salvajes.'
      ];
      gameCategories = ['Superhéroes', 'Survival Horror', 'Simulación de Carreras', 'Lucha', 'Mundo Abierto', 'Acción y Aventura'];
    }

    return SizedBox(
      height: 220,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = (constraints.maxWidth - 20) / 4;
          final double cardPadding = (constraints.maxWidth - (cardWidth * 3)) / 5;
          final double viewportFraction =
              (cardWidth + cardPadding * 2) / constraints.maxWidth;

          return PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1000,
            controller: PageController(
              viewportFraction: viewportFraction,
              initialPage: 0,
            ),
            physics: const ClampingScrollPhysics(),
            pageSnapping: true,
            clipBehavior: Clip.none,
            scrollBehavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            itemBuilder: (context, index) {
              final int actualIndex = index % imagePaths.length;
              String imagePath = imagePaths[actualIndex];
              String price = '${(actualIndex + 1) * 10}.00€';

              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: cardWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: cardPadding / 2),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            backgroundColor: Colors.white,
                            title: Text(
                              gameNames[actualIndex],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            content: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 250,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Categoría: ${gameCategories[actualIndex]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Descripción: ${gameDescriptions[actualIndex]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    actualIndex % 2 == 0
                                        ? Row(
                                            children: [
                                              Text(
                                                'Precio Original: ${price}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  decoration:
                                                      TextDecoration.lineThrough,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Precio con Descuento: ${(double.parse(price.split('€')[0]) * 0.8).toStringAsFixed(2)}€',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'Precio: ${price}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Cerrar',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: _HoverGameCard(
                        imageUrl: imagePath,
                        price: price,
                        width: cardWidth,
                        discount: actualIndex % 2 == 0 ? '20% OFF' : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade500, Colors.deepPurple.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '¿Tienes alguna consulta? Contáctanos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '¡Estamos aquí para ayudarte con todo lo que necesites!\n\n'
            'Puedes escribirnos a través de nuestras redes sociales o '
            'enviarnos un correo directamente a info@gamestore.com',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook),
                color: Colors.blueAccent,
                iconSize: 30,
                onPressed: () {},
              ),
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(Icons.twelve_mp),
                color: Colors.blueAccent,
                iconSize: 30,
                onPressed: () {},
              ),
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(Icons.install_desktop),
                color: Colors.pinkAccent,
                iconSize: 30,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '© 2025 Game Store, Todos los derechos reservados',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDrawerHeaderItem extends StatefulWidget {
  final Widget child;
  final String? route;

  const _AnimatedDrawerHeaderItem({
    required this.child,
    this.route,
  });

  @override
  State<_AnimatedDrawerHeaderItem> createState() =>
      _AnimatedDrawerHeaderItemState();
}

class _AnimatedDrawerHeaderItemState
    extends State<_AnimatedDrawerHeaderItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.route != null
            ? () => Navigator.pushNamed(context, widget.route!)
            : null,
        child: Container(
          color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
          padding: const EdgeInsets.only(
              left: 16.0, top: 16.0, right: 16.0, bottom: 12.0),
          child: widget.child,
        ),
      ),
    );
  }
}

class _AnimatedDrawerItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final String route;

  const _AnimatedDrawerItem({
    required this.icon,
    required this.text,
    required this.route,
  });

  @override
  State<_AnimatedDrawerItem> createState() => _AnimatedDrawerItemState();
}

class _AnimatedDrawerItemState extends State<_AnimatedDrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
        child: ListTile(
          leading: Icon(widget.icon, color: Colors.white, size: 26),
          title: AnimatedDefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            duration: const Duration(milliseconds: 150),
            child: Text(widget.text),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, widget.route);
          },
          hoverColor: Colors.transparent,
        ),
      ),
    );
  }
}

class _HoverGameCard extends StatefulWidget {
  final String imageUrl;
  final String price;
  final String? discount;
  final double width;

  const _HoverGameCard({
    required this.imageUrl,
    required this.price,
    this.discount,
    required this.width,
  });

  @override
  State<_HoverGameCard> createState() => _HoverGameCardState();
}

class _HoverGameCardState extends State<_HoverGameCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          width: widget.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Image.asset(
                  widget.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white54, size: 40),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    color: Colors.black.withOpacity(0.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        if (widget.discount != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.discount!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
