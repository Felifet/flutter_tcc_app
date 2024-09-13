import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/controllers/registro_manejo_controller.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:flutter_tcc_app/src/services/ciclo_service.dart';
import 'package:flutter_tcc_app/src/services/gleba_service.dart';
import 'package:flutter_tcc_app/src/services/manejo_service.dart';

class RegistroManejoEditScreen extends StatefulWidget {
  final RegistroManejo? registroManejo;

  const RegistroManejoEditScreen({Key? key, this.registroManejo})
      : super(key: key);

  @override
  _RegistroManejoEditScreenState createState() =>
      _RegistroManejoEditScreenState();
}

class _RegistroManejoEditScreenState extends State<RegistroManejoEditScreen> {
  final RegistroManejoController _controller = RegistroManejoController();
  final _formKey = GlobalKey<FormState>();

  // Campos de seleção
  int? selectedCicloId;
  int? selectedGlebaId;
  int? selectedManejoId;

  late Future<List<Ciclo>> _ciclosFuture;
  late Future<List<Gleba>> _glebasFuture;
  late Future<List<Manejo>> _manejosFuture;

  @override
  void initState() {
    super.initState();
    _ciclosFuture = CicloService().getCiclos();
    _glebasFuture = GlebaService().getGlebas();
    _manejosFuture = ManejoService().getManejos();

    // Preenche com os dados existentes, se estiver editando
    if (widget.registroManejo != null) {
      selectedCicloId = widget.registroManejo!.cicloId;
      selectedGlebaId = widget.registroManejo!.glebaId;
      selectedManejoId = widget.registroManejo!.manejoId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Registro de Manejo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de seleção para Ciclo
              FutureBuilder<List<Ciclo>>(
                future: _ciclosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar ciclos');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum ciclo encontrado');
                  } else {
                    return DropdownButtonFormField<int>(
                      value: selectedCicloId,
                      onChanged: (value) {
                        setState(() {
                          selectedCicloId = value;
                        });
                      },
                      items: snapshot.data!.map((ciclo) {
                        return DropdownMenuItem<int>(
                          value: ciclo.id,
                          child: Text(ciclo.descricao),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecione um Ciclo',
                      ),
                      validator: (value) => value == null
                          ? 'Por favor, selecione um ciclo'
                          : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Campo de seleção para Gleba
              FutureBuilder<List<Gleba>>(
                future: _glebasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar glebas');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhuma gleba encontrada');
                  } else {
                    return DropdownButtonFormField<int>(
                      value: selectedGlebaId,
                      onChanged: (value) {
                        setState(() {
                          selectedGlebaId = value;
                        });
                      },
                      items: snapshot.data!.map((gleba) {
                        return DropdownMenuItem<int>(
                          value: gleba.id,
                          child: Text(gleba.nomeIdentificador),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecione uma Gleba',
                      ),
                      validator: (value) => value == null
                          ? 'Por favor, selecione uma gleba'
                          : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Campo de seleção para Manejo
              FutureBuilder<List<Manejo>>(
                future: _manejosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar manejos');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum manejo encontrado');
                  } else {
                    return DropdownButtonFormField<int>(
                      value: selectedManejoId,
                      onChanged: (value) {
                        setState(() {
                          selectedManejoId = value;
                        });
                      },
                      items: snapshot.data!.map((manejo) {
                        return DropdownMenuItem<int>(
                          value: manejo.id,
                          child: Text(manejo.nome),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecione um Manejo',
                      ),
                      validator: (value) => value == null
                          ? 'Por favor, selecione um manejo'
                          : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // Botão para salvar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Chama o método para salvar o registro de manejo
                    _controller.saveRegistroManejo(RegistroManejo(
                      id: widget.registroManejo?.id ?? 0,
                      datetime: DateTime.now(),
                      cicloId: selectedCicloId!,
                      glebaId: selectedGlebaId!,
                      manejoId: selectedManejoId!,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
