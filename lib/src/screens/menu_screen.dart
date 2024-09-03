import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de produtos
                Navigator.pushNamed(context, '/products');
              },
              child: const Text('Produtos'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de produtos
                Navigator.pushNamed(context, '/glebas');
              },
              child: const Text('Glebas'),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Placeholder para funcionalidade de backup futura
              },
              child: const Text('Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
