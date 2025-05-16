import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegúrate de tener Provider importado
import 'package:menu/src/login_page.dart';
import 'package:menu/src/appmenu.dart';
import 'package:menu/src/home_page.dart';
import 'package:menu/src/configuration_page.dart';
import 'package:menu/src/company_page.dart';
import 'package:menu/src/clases_page.dart';
import 'package:menu/src/register_page.dart';
import 'package:menu/src/user_manager.dart';
import 'package:menu/src/carrito_provider.dart';
import 'package:menu/src/carrito_page.dart'; // Asegúrate de importar CarritoPage

void main() {
  final userManager = UserManager(); // Inicializar el UserManager

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CarritoProvider()), // Proveedor del carrito
        Provider<UserManager>(create: (_) => userManager), // Proveedor de UserManager
      ],
      child: MyApp(userManager: userManager),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserManager userManager;

  const MyApp({Key? key, required this.userManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Inter',
      ),
      initialRoute: '/login', // Asegúrate de tener la ruta correcta inicial
      routes: {
        '/login': (context) => LoginPage(userManager: userManager),
        '/': (context) => const MenuPrincipal(), // Página de menú principal
        '/home': (context) => const HomePage(),
        '/configuration': (context) => const ConfigurationPage(),
        '/company': (context) => const CompanyPage(),
        '/clases': (context) => const ClasesPage(),
        '/register': (context) => RegisterPage(userManager: userManager),
        '/carrito': (context) => const CarritoPage(), // Ruta al carrito
      },
    );
  }
}
