import 'package:flutter/material.dart';
import 'pago_page.dart';

// Página principal de la app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const HomePage(),
    );
  }
}

// Página principal donde se muestra el carrito
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _cartItems = [];

  // Agregar al carrito
  void _addToCart(Map<String, dynamic> game) {
    setState(() {
      _cartItems.add(game);
    });
  }

  // Método para construir las tarjetas de configuración
  Widget _buildSettingTile({
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5), width: 1),
        ),
        child: Row(
          children: [
            if (leading != null) leading,
            if (leading != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) title,
                  if (title != null && subtitle != null) const SizedBox(height: 4),
                  if (subtitle != null) subtitle,
                ],
              ),
            ),
            if (trailing != null) trailing,
            const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF757575)),
          ],
        ),
      ),
    );
  }

  // Método para construir el resumen de actividad
  Widget _buildHighlightCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: _buildSettingTile(
        leading: const Icon(Icons.insights, color: Colors.deepPurpleAccent, size: 30),
        title: const Text(
          'Resumen de Actividad',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        subtitle: Text(
          'Consulta tus métricas y reportes recientes.',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        onTap: () {
          _showCartDetails(context);
        },
      ),
    );
  }

  // Método para mostrar los detalles del carrito
  void _showCartDetails(BuildContext context) {
    double total = 0;
    for (var item in _cartItems) {
      final price = item['price']?.replaceAll('€', '');
      if (price != null) {
        total += double.tryParse(price) ?? 0;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Carrito'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._cartItems.map((item) {
                  return Text(
                    '${item['name']} - ${item['price']}',
                    style: const TextStyle(fontSize: 16),
                  );
                }).toList(),
                const SizedBox(height: 12),
                Text(
                  'Total: ${total.toStringAsFixed(2)}€',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCartItem({required Map<String, dynamic> itemData}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: _buildSettingTile(
        leading: Icon(itemData['icon'] ?? Icons.shopping_cart, color: Colors.deepPurpleAccent, size: 30),
        title: Text(
          itemData['name'] ?? 'Producto sin nombre',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        subtitle: itemData['price'] != null
            ? Text(
                'Precio: ${itemData['price']}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              )
            : null,
        onTap: () {},
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              _cartItems.remove(itemData);
            });
          },
        ),
      ),
    );
  }

  Widget _buildShoppingCartSection() {
    double total = 0;
    for (var item in _cartItems) {
      final price = item['price']?.replaceAll('€', '');
      if (price != null) {
        total += double.tryParse(price) ?? 0;
      }
    }

    return LayoutBuilder(builder: (BuildContext layoutContext, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.deepPurpleAccent, size: 32),
                const SizedBox(width: 8),
                Text(
                  'Tu Carrito (${_cartItems.length})',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._cartItems.map((item) => _buildCartItem(itemData: item)).toList(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: ${total.toStringAsFixed(2)}€',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _cartItems.isNotEmpty
                  ? () {
                      Navigator.push(
                        layoutContext,
                        MaterialPageRoute(builder: (context) => const PagoPage()),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _cartItems.isNotEmpty ? Colors.deepPurpleAccent : Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 10,
              ),
              child: const Text('Ir a Pagar', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'GameZone',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple.withOpacity(0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        child: ListView(
          children: [
            const Text(
              '¡Bienvenido de nuevo!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            _buildHighlightCard(),
            const SizedBox(height: 25),
            const Text(
              'Tu Carrito',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildShoppingCartSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppMenu(onAddToCart: _addToCart),
            ),
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        icon: const Icon(Icons.add),
        label: const Text('Ir al Menú'),
      ),
    );
  }
}

// Menú de juegos
class AppMenu extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddToCart;

  const AppMenu({super.key, required this.onAddToCart});

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  bool _showCartButton = false;

  final List<Map<String, dynamic>> _gameList = [
    {'name': 'Days Gone', 'originalPrice': '10.00€', 'price': '8.00€', 'icon': Icons.directions_bike},
    {'name': 'Guardianes de la Galaxia', 'price': '20.00€', 'icon': Icons.security},
    {'name': 'Resident Evil 4 Remake', 'originalPrice': '30.00€', 'price': '24.00€', 'icon': Icons.warning},
    {'name': 'God of War', 'price': '40.00€', 'icon': Icons.face},
    {'name': 'Resident Evil Village', 'originalPrice': '50.00€', 'price': '40.00€', 'icon': Icons.local_fire_department},
    {'name': 'Bloodborne', 'price': '60.00€', 'icon': Icons.vpn_lock},
    {'name': 'Uncharted 4', 'originalPrice': '80.00€', 'price': '64.00€', 'icon': Icons.local_activity},
    {'name': 'Call of Duty: Modern Warfare', 'price': '20.00€', 'icon': Icons.sports_esports},
    {'name': 'Battlefield 1', 'originalPrice': '30.00€', 'price': '24.00€', 'icon': Icons.cloud_circle},
    {'name': 'The Callisto Protocol', 'price': '40.00€', 'icon': Icons.access_alarm},
    {'name': 'Until Dawn', 'originalPrice': '50.00€', 'price': '40.00€', 'icon': Icons.umbrella},
    {'name': 'Doom Eternal', 'price': '60.00€', 'icon': Icons.devices},
    {'name': 'Spider-Man', 'originalPrice': '10.00€', 'price': '8.00€', 'icon': Icons.account_tree},
    {'name': 'Resident Evil 3 Remake', 'price': '20.00€', 'icon': Icons.warning_amber_rounded},
    {'name': 'Gran Turismo Sport', 'originalPrice': '30.00€', 'price': '24.00€', 'icon': Icons.directions_car},
    {'name': 'Mortal Kombat X', 'price': '40.00€', 'icon': Icons.sports_mma},
    {'name': 'Grand Theft Auto V', 'originalPrice': '60.00€', 'price': '45.00€', 'icon': Icons.directions_car},
  ];

  void _addGameToCart(BuildContext context, Map<String, dynamic> gameData) {
    widget.onAddToCart(gameData);
    setState(() {
      _showCartButton = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${gameData['name']} añadido al carrito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de Juegos'),
        backgroundColor: Colors.deepPurple.withOpacity(0.8),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _gameList.length,
            itemBuilder: (context, index) {
              final game = _gameList[index];
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 67, 28, 176),
                    child: Icon(game['icon'], color: Colors.white),
                  ),
                  title: Text(
                    game['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: game['originalPrice'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio Original: ${game['originalPrice']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              'Precio con Descuento: ${game['price']}',
                              style: const TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ],
                        )
                      : Text(
                          'Precio: ${game['price']}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                  trailing: ElevatedButton(
                    onPressed: () => _addGameToCart(context, game),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Añadir', style: TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ),
              );
            },
          ),
          if (_showCartButton)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Ir al Carrito'),
                backgroundColor: Colors.deepPurpleAccent,
              ),
            ),
        ],
      ),
    );
  }
}
