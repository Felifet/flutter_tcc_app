import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import '../../models/cultivar_model.dart';
import '../../controllers/cultivar_controller.dart';

class CultivarEditScreen extends StatefulWidget {
  final Cultivar?
      cultivar; // Pode ser nulo se estivermos adicionando uma nova cultivar

  const CultivarEditScreen({Key? key, this.cultivar}) : super(key: key);

  @override
  _CultivarEditScreenState createState() => _CultivarEditScreenState();
}

class _CultivarEditScreenState extends State<CultivarEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final CultivarController _cultivarController = CultivarController();

  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador de texto com o nome da cultivar se estivermos editando
    _nomeController = TextEditingController(
      text: widget.cultivar != null ? widget.cultivar!.nome : '',
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _saveCultivar() async {
    if (_formKey.currentState!.validate()) {
      if (widget.cultivar == null) {
        // Criar uma nova cultivar
        Cultivar newCultivar = Cultivar(nome: _nomeController.text);
        await _cultivarController.saveCultivar(newCultivar);
      } else {
        // Atualizar a cultivar existente
        Cultivar updatedCultivar = Cultivar(
          id: widget.cultivar!.id,
          nome: _nomeController.text,
        );
        await _cultivarController.saveCultivar(updatedCultivar);
      }

      Navigator.pop(context); // Volta para a lista após salvar
    }
  }

  void _confirmDeleteCultivar() async {
    if (widget.cultivar != null) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text(
              'Você tem certeza de que deseja excluir esta cultivar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        ),
      );

      if (shouldDelete == true) {
        await _cultivarController.deleteCultivar(widget.cultivar!.id!);
        Navigator.pop(context); // Volta para a lista após exclusão
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cultivar == null ? 'Adicionar Cultivar' : 'Editar Cultivar',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration:
                    const InputDecoration(labelText: 'Nome da Cultivar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da cultivar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.cultivar != null)
                    SizedBox(
                      width: 120, // Tamanho fixo para o botão "Excluir"
                      child: ElevatedButton(
                        onPressed: _confirmDeleteCultivar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Excluir'),
                      ),
                    ),
                  SizedBox(
                    width: 120, // Tamanho fixo para o botão "Salvar"
                    child: ElevatedButton(
                      onPressed: _saveCultivar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child:
                          Text(widget.cultivar == null ? 'Salvar' : 'Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
}
