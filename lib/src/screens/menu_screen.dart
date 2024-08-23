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
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Home Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar para outra tela no futuro
              },
              child: const Text('Outra Tela'),
            ),
          ],
        ),
      ),
    );
  }
}
