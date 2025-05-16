// carrito_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'carrito_provider.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoProvider = context.watch<CarritoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de Compras')),
      body: ListView(
        children: [
          ...carritoProvider.cartItems.map((item) {
            return ListTile(
              title: Text(item['name']),
              subtitle: Text(item['price']),
              leading: Icon(item['icon']),
            );
          }).toList(),
          ListTile(
            title: const Text('Total'),
            subtitle: Text('${carritoProvider.totalAmount}€'),
          ),
        ],
      ),
    );
  }
}
