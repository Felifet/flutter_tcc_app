import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';
import '../../services/ciclo_service.dart';
import '../../models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';

class CicloEditScreen extends StatefulWidget {
  final Ciclo? ciclo;

  const CicloEditScreen({Key? key, this.ciclo}) : super(key: key);

  @override
  _CicloEditScreenState createState() => _CicloEditScreenState();
}

class _CicloEditScreenState extends State<CicloEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _descricaoController =
        TextEditingController(text: widget.ciclo?.descricao ?? '');
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _saveCiclo() async {
    if (_formKey.currentState!.validate()) {
      final ciclo = Ciclo(
        id: widget.ciclo?.id,
        descricao: _descricaoController.text,
      );

      if (widget.ciclo == null) {
        await DBHelper().insertCiclo(ciclo);
      } else {
        await DBHelper().updateCiclo(ciclo);
      }

      Navigator.pop(context);
    }
  }

  void _confirmDeleteCiclo() async {
    if (widget.ciclo != null) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Você tem certeza de que deseja excluir este ciclo?'),
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
        await CicloService().deleteCiclo(widget.ciclo!.id!);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ciclo == null ? 'Adicionar Ciclo' : 'Editar Ciclo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma descrição!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _confirmDeleteCiclo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Excluir'),
                  ),
                  ElevatedButton(
                    onPressed: _saveCiclo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Salvar'),
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
          height: 50, // Ajuste a altura da BottomAppBar
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
                  Navigator.pushReplacement(context,
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
