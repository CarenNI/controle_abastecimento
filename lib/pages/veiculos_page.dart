import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/veiculo_model.dart';
import 'veiculo_form_page.dart';

class VeiculosPage extends StatelessWidget {
  const VeiculosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    final veiculosRef = FirebaseFirestore.instance
        .collection('users')
        .doc(usuario.uid)
        .collection('veiculos');

    return Scaffold(
      appBar: AppBar(title: const Text('Meus veículos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: veiculosRef.orderBy('modelo').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar veículos: ${snapshot.error}'),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado'));
          }

          final veiculos = docs
              .map(
                (doc) => Veiculo.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();

          return ListView.separated(
            itemCount: veiculos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final v = veiculos[index];
              return ListTile(
                title: Text('${v.modelo} - ${v.placa}'),
                subtitle: Text('${v.marca} • ${v.ano} • ${v.tipoCombustivel}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await veiculosRef.doc(v.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Veículo excluído')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VeiculoFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 
