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
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60), // Tamanho mínimo do botão
              ),
              child: const Text('Produtos'),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de glebas
                Navigator.pushNamed(context, '/glebas');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60), // Tamanho mínimo do botão
              ),
              child: const Text('Glebas'),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de ciclos
                Navigator.pushNamed(context, '/ciclos');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60), // Tamanho mínimo do botão
              ),
              child: const Text('Ciclos'),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de ciclos
                Navigator.pushNamed(context, '/doencas_pragas');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60), // Tamanho mínimo do botão
              ),
              child: const Text('Doenças/Pragas'),
            ),
            const SizedBox(height: 16.0), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                // Placeholder para funcionalidade de backup futura
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60), // Tamanho mínimo do botão
              ),
              child: const Text('Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
