import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/abastecimento_model.dart';

class AbastecimentosPage extends StatelessWidget {
  const AbastecimentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    final abastecimentosRef = FirebaseFirestore.instance
        .collection('users')
        .doc(usuario.uid)
        .collection('abastecimentos');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de abastecimentos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: abastecimentosRef.orderBy('data', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar abastecimentos: ${snapshot.error}'),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum abastecimento registrado'));
          }

          final abastecimentos = docs
              .map(
                (doc) => Abastecimento.fromFirestore(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();

          return ListView.separated(
            itemCount: abastecimentos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final a = abastecimentos[index];
              final dataStr = a.data.toString().substring(0, 10);
              final valorLitro = a.quantidadeLitros > 0
                  ? a.valorPago / a.quantidadeLitros
                  : 0.0;

              return ListTile(
                title: Text(
                  '$dataStr • ${a.tipoCombustivel}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Litros: ${a.quantidadeLitros.toStringAsFixed(2)}  '
                  'Valor: R\$ ${a.valorPago.toStringAsFixed(2)}\n'
                  'Km: ${a.quilometragem}  '
                  'R\$/L: ${valorLitro.toStringAsFixed(2)}'
                  '${a.consumo != null ? '\nConsumo: ${a.consumo!.toStringAsFixed(2)} km/L' : ''}'
                  '${a.observacao != null && a.observacao!.isNotEmpty ? '\nObs: ${a.observacao}' : ''}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await abastecimentosRef.doc(a.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abastecimento excluído')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
