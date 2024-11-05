import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 5, 94, 105),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), fontSize: 22),
        iconTheme: const IconThemeData(color: Color(0xFF3C8C81)),
        automaticallyImplyLeading: false, // Remove o botão de voltar
        toolbarHeight: 56, // Ajuste a altura da AppBar superior
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0), // Espaçamento entre os botões
            child: _buildMenuButton(context, item.label, item.route, item.icon),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 5, 94, 105),
        child: Container(
          height: 20, // Ajuste a altura da BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.list),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenuScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app_sharp),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lista de itens do menu com ícones, rótulos e rotas
  final List<MenuItem> _menuItems = [
    MenuItem(label: 'Aplicações', route: '/aplicacoes', icon: Icons.add_task),
    MenuItem(label: 'Backup', route: '/backup', icon: Icons.backup),
    MenuItem(label: 'Ciclos', route: '/ciclos', icon: Icons.autorenew),
    MenuItem(label: 'Cultivares', route: '/cultivares', icon: Icons.grass),
    MenuItem(
        label: 'Doenças/Pragas',
        route: '/doencas_pragas',
        icon: Icons.warning_amber),
    MenuItem(
        label: 'Estágios Fenológicos',
        route: '/estagios_fenologicos',
        icon: Icons.calendar_today),
    MenuItem(label: 'Glebas', route: '/glebas', icon: Icons.landscape),
    MenuItem(label: 'Gráficos', route: '/graficos', icon: Icons.graphic_eq),
    MenuItem(
        label: 'Importação de Produtos',
        route: '/importacao_produtos',
        icon: Icons.install_desktop),
    MenuItem(
        label: 'Manejos', route: '/manejos', icon: Icons.workspaces_rounded),
    MenuItem(
        label: 'Produtos',
        route: '/products',
        icon: Icons.production_quantity_limits),
    MenuItem(
        label: 'Registrar Estágio Fenológico',
        route: '/registro_estagio_list',
        icon: Icons.add_alarm),
    MenuItem(
        label: 'Registrar Manejo',
        route: '/registro_manejo_list',
        icon: Icons.add),
  ];

  // Método para construir os botões do menu
  Widget _buildMenuButton(
      BuildContext context, String label, String route, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF3C8C81), // Cor de fundo do botão (verde-água)
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
              color: Colors.white,
            ), // Ícone à esquerda
            const SizedBox(width: 16.0), // Espaçamento entre o ícone e o texto
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
                overflow: TextOverflow
                    .ellipsis, // Adiciona reticências para texto longo
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
