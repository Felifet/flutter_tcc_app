import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart'; // Atualize a importação

class ProductEditScreen extends StatefulWidget {
  final Product? product;

  const ProductEditScreen({super.key, this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tipoController;
  late TextEditingController _nomeController;
  late TextEditingController _principioAtivoController;
  late TextEditingController _classificacaoToxicologicaController;
  late TextEditingController _formulacaoController;
  late TextEditingController _dosagemComercialController;
  late TextEditingController _intervaloDeSegurancaController;
  late TextEditingController _vigenciaController;

  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _tipoController = TextEditingController(text: widget.product?.tipo ?? '');
    _nomeController =
        TextEditingController(text: widget.product?.nomeComercial ?? '');
    _principioAtivoController =
        TextEditingController(text: widget.product?.principioAtivo ?? '');
    _classificacaoToxicologicaController = TextEditingController(
        text: widget.product?.classificacaoToxicologica ?? '');
    _formulacaoController =
        TextEditingController(text: widget.product?.formulacao ?? '');
    _dosagemComercialController = TextEditingController(
        text: widget.product?.dosagemComercial?.toString() ?? '');
    _intervaloDeSegurancaController = TextEditingController(
        text: widget.product?.intervaloDeSeguranca.toString() ?? '');
    _vigenciaController =
        TextEditingController(text: widget.product?.vigencia?.toString() ?? '');
  }

  @override
  void dispose() {
    _tipoController.dispose();
    _nomeController.dispose();
    _principioAtivoController.dispose();
    _classificacaoToxicologicaController.dispose();
    _formulacaoController.dispose();
    _dosagemComercialController.dispose();
    _intervaloDeSegurancaController.dispose();
    _vigenciaController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id,
        tipo: _tipoController.text,
        nomeComercial: _nomeController.text,
        principioAtivo: _principioAtivoController.text,
        classificacaoToxicologica: _classificacaoToxicologicaController.text,
        formulacao: _formulacaoController.text,
        dosagemComercial:
            double.tryParse(_dosagemComercialController.text) ?? 0,
        intervaloDeSeguranca:
            int.tryParse(_intervaloDeSegurancaController.text) ?? 0,
        vigencia: int.tryParse(_vigenciaController.text) ?? 0,
      );

      if (widget.product == null) {
        await _productService.addProduct(product);
      } else {
        await _productService.updateProduct(product);
      }

      Navigator.pop(context);
    }
  }

  void _deleteProduct() async {
    if (widget.product != null) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content:
                const Text('Tem certeza de que deseja excluir este produto?'),
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
          );
        },
      );

      if (confirm == true) {
        await _productService.deleteProduct(widget.product!.id!);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.product == null ? 'Adicionar Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _tipoController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o tipo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nomeController,
                  decoration:
                      const InputDecoration(labelText: 'Nome Comercial'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome comercial';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _principioAtivoController,
                  decoration:
                      const InputDecoration(labelText: 'Princípio Ativo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o princípio ativo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _classificacaoToxicologicaController,
                  decoration: const InputDecoration(
                      labelText: 'Classificação Toxicológica'),
                ),
                TextFormField(
                  controller: _formulacaoController,
                  decoration: const InputDecoration(labelText: 'Formulação'),
                ),
                TextFormField(
                  controller: _dosagemComercialController,
                  decoration:
                      const InputDecoration(labelText: 'Dosagem Comercial'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _intervaloDeSegurancaController,
                  decoration: const InputDecoration(
                      labelText: 'Intervalo de Segurança'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _vigenciaController,
                  decoration: const InputDecoration(labelText: 'Vigência'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _deleteProduct,
                          child: const Text('Excluir'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Salvar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
