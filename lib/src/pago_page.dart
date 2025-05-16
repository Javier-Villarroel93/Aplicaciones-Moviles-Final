import 'package:flutter/material.dart';

class PagoPage extends StatelessWidget {
  const PagoPage({super.key});

  void _mostrarDialogoPago({
    required BuildContext context,
    required String metodo,
  }) {
    final nombreController = TextEditingController();
    final campoExtraController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pagar con $metodo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del titular',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: campoExtraController,
                decoration: InputDecoration(
                  labelText: metodo == 'Tarjeta'
                      ? 'Número de Tarjeta'
                      : 'Correo de PayPal',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context); // Cierra diálogo
                Navigator.pop(context); // Vuelve a HomePage
              },
            ),
            ElevatedButton(
              child: const Text('Pagar'),
              onPressed: () {
                final nombre = nombreController.text.trim();
                final campoExtra = campoExtraController.text.trim();

                if (nombre.isEmpty || campoExtra.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                Navigator.pop(context); // Cierra diálogo
                Navigator.pop(context); // Regresa a HomePage

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pago exitoso con $metodo. ¡Gracias por tu compra!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.deepPurpleAccent.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.deepPurpleAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF757575)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Método de Pago',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple.withOpacity(0.8),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: ListView(
          children: [
            const Text(
              'Selecciona un método de pago:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(
              context: context,
              icon: Icons.credit_card,
              title: 'Tarjeta',
              description: 'Paga con tarjeta de crédito o débito',
              onTap: () => _mostrarDialogoPago(context: context, metodo: 'Tarjeta'),
            ),
            _buildPaymentOption(
              context: context,
              icon: Icons.account_balance_wallet,
              title: 'PayPal',
              description: 'Usa tu cuenta de PayPal para pagar',
              onTap: () => _mostrarDialogoPago(context: context, metodo: 'PayPal'),
            ),
          ],
        ),
      ),
    );
  }
}
