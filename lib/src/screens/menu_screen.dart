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
                Navigator.pushNamed(context, '/products');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Produtos'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/glebas');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Glebas'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ciclos');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Ciclos'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doencas_pragas');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Doenças/Pragas'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cultivares');
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Cultivares'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Placeholder para funcionalidade de backup futura
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20.0),
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
