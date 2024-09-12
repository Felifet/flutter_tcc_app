import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(
            fontSize: 24.0, // Tamanho da fonte do título
            fontWeight: FontWeight.bold, // Negrito para destacar
          ),
        ),
        centerTitle: true, // Centralizar o título
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildMenuButton(context, 'Produtos', '/products'),
            _buildMenuButton(context, 'Glebas', '/glebas'),
            _buildMenuButton(context, 'Ciclos', '/ciclos'),
            _buildMenuButton(context, 'Doenças/Pragas', '/doencas_pragas'),
            _buildMenuButton(context, 'Cultivares', '/cultivares'),
            _buildMenuButton(
                context, 'Estágios Fenológicos', '/estagios_fenologicos'),
            _buildMenuButton(
                context, 'Manejos', '/manejos'), // Novo item adicionado
            _buildMenuButton(context, 'Backup',
                '/backup'), // Ajuste para a funcionalidade de backup futura
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String label, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 8.0), // Espaçamento entre os botões
      width: 200, // Largura fixa para todos os botões
      height: 60, // Altura fixa para todos os botões
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20.0),
          backgroundColor: Colors
              .blue, // Cor de fundo dos botões (pode ser ajustada conforme necessário)
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
