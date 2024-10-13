import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

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
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Atualizado para 2 colunas
          crossAxisSpacing: 16.0, // Espaçamento horizontal entre os itens
          mainAxisSpacing: 16.0, // Espaçamento vertical entre os itens
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildMenuButton(context, item.label, item.route, item.icon);
        },
      ),
    );
  }

  // Lista de itens do menu com ícones, rótulos e rotas
  final List<MenuItem> _menuItems = [
    MenuItem(label: 'Produtos', route: '/products', icon: Icons.shopping_cart),
    MenuItem(label: 'Glebas', route: '/glebas', icon: Icons.landscape),
    MenuItem(label: 'Ciclos', route: '/ciclos', icon: Icons.autorenew),
    MenuItem(
        label: 'Doenças/Pragas', route: '/doencas_pragas', icon: Icons.warning),
    MenuItem(label: 'Cultivares', route: '/cultivares', icon: Icons.grass),
    MenuItem(
        label: 'Estágios Fenológicos',
        route: '/estagios_fenologicos',
        icon: Icons.calendar_today),
    MenuItem(label: 'Manejos', route: '/manejos', icon: Icons.adjust),
    MenuItem(
        label: 'Registrar Manejo',
        route: '/registro_manejo_list',
        icon: Icons.add),
    MenuItem(
        label: 'Registrar Estágio Fenológico',
        route: '/registro_estagio_list',
        icon: Icons.add),
    MenuItem(label: 'Aplicações', route: '/aplicacoes', icon: Icons.add),
    MenuItem(label: 'Backup', route: '/backup', icon: Icons.backup),
    MenuItem(
        label: 'Importação de Produtos',
        route: '/importacao_produtos',
        icon: Icons.install_desktop),
  ];

  // Método para construir os botões do menu
  Widget _buildMenuButton(
      BuildContext context, String label, String route, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40.0, color: Colors.white), // Ícone
            const SizedBox(height: 8.0),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  overflow: TextOverflow
                      .ellipsis, // Adiciona reticências para texto longo
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe para definir os itens do menu
class MenuItem {
  final String label;
  final String route;
  final IconData icon;

  MenuItem({required this.label, required this.route, required this.icon});
}
