import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/veiculo_model.dart';
import '../models/abastecimento_model.dart';

class AbastecimentoFormPage extends StatefulWidget {
  const AbastecimentoFormPage({super.key});

  @override
  State<AbastecimentoFormPage> createState() => _AbastecimentoFormPageState();
}

class _AbastecimentoFormPageState extends State<AbastecimentoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _dataController = TextEditingController();
  final _litrosController = TextEditingController();
  final _valorPagoController = TextEditingController();
  final _kmController = TextEditingController();
  final _consumoController = TextEditingController();
  final _observacaoController = TextEditingController();

  String? _tipoCombustivelSelecionado;
  Veiculo? _veiculoSelecionado;
  bool _salvando = false;

  List<Veiculo> _veiculos = [];

  @override
  void initState() {
    super.initState();
    _dataController.text = DateTime.now().toIso8601String().substring(
      0,
      10,
    ); // formato simples
    _carregarVeiculos();
  }

  Future<void> _carregarVeiculos() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;

    final veiculosRef = FirebaseFirestore.instance
        .collection('users')
        .doc(usuario.uid)
        .collection('veiculos');

    final snapshot = await veiculosRef.get();
    final lista = snapshot.docs
        .map((doc) => Veiculo.fromFirestore(doc.id, doc.data()))
        .toList();

    setState(() {
      _veiculos = lista;
    });
  }

  @override
  void dispose() {
    _dataController.dispose();
    _litrosController.dispose();
    _valorPagoController.dispose();
    _kmController.dispose();
    _consumoController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarAbastecimento() async {
    if (!_formKey.currentState!.validate()) return;

    if (_veiculoSelecionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um veículo')));
      return;
    }

    if (_tipoCombustivelSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o tipo de combustível')),
      );
      return;
    }

    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado')));
      return;
    }

    setState(() => _salvando = true);

    try {
      final data = DateTime.parse(_dataController.text.trim());
      final litros = double.parse(_litrosController.text.trim());
      final valorPago = double.parse(_valorPagoController.text.trim());
      final km = int.parse(_kmController.text.trim());
      final consumo = _consumoController.text.trim().isEmpty
          ? null
          : double.parse(_consumoController.text.trim());
      final observacao = _observacaoController.text.trim().isEmpty
          ? null
          : _observacaoController.text.trim();

      final abastecimento = Abastecimento(
        id: '',
        veiculoId: _veiculoSelecionado!.id,
        data: data,
        quantidadeLitros: litros,
        valorPago: valorPago,
        quilometragem: km,
        tipoCombustivel: _tipoCombustivelSelecionado!,
        consumo: consumo,
        observacao: observacao,
      );

      final abastecimentosRef = FirebaseFirestore.instance
          .collection('users')
          .doc(usuario.uid)
          .collection('abastecimentos');

      await abastecimentosRef.add(abastecimento.toMap());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abastecimento salvo com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar abastecimento: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final veiculoItems = _veiculos
        .map(
          (v) => DropdownMenuItem<Veiculo>(
            value: v,
            child: Text('${v.modelo} - ${v.placa}'),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar abastecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _veiculos.isEmpty
            ? const Center(
                child: Text(
                  'Cadastre um veículo antes de registrar abastecimentos.',
                ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<Veiculo>(
                      value: _veiculoSelecionado,
                      items: veiculoItems,
                      onChanged: (v) {
                        setState(() {
                          _veiculoSelecionado = v;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Veículo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dataController,
                      decoration: const InputDecoration(
                        labelText: 'Data (AAAA-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a data';
                        }
                        try {
                          DateTime.parse(value);
                        } catch (_) {
                          return 'Data inválida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _litrosController,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade de litros',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a quantidade de litros';
                        }
                        final n = double.tryParse(value);
                        if (n == null || n <= 0) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _valorPagoController,
                      decoration: const InputDecoration(
                        labelText: 'Valor pago',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o valor pago';
                        }
                        final n = double.tryParse(value);
                        if (n == null || n <= 0) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _kmController,
                      decoration: const InputDecoration(
                        labelText: 'Quilometragem',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a quilometragem';
                        }
                        final n = int.tryParse(value);
                        if (n == null || n <= 0) {
                          return 'Valor inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _tipoCombustivelSelecionado,
                      items: const [
                        DropdownMenuItem(
                          value: 'Gasolina',
                          child: Text('Gasolina'),
                        ),
                        DropdownMenuItem(
                          value: 'Etanol',
                          child: Text('Etanol'),
                        ),
                        DropdownMenuItem(
                          value: 'Diesel',
                          child: Text('Diesel'),
                        ),
                        DropdownMenuItem(value: 'GNV', child: Text('GNV')),
                      ],
                      onChanged: (valor) {
                        setState(() {
                          _tipoCombustivelSelecionado = valor;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de combustível',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _consumoController,
                      decoration: const InputDecoration(
                        labelText: 'Consumo (opcional, km/L)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _observacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Observação (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _salvando ? null : _salvarAbastecimento,
                        child: _salvando
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
