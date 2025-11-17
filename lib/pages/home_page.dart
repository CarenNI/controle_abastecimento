import 'package:flutter/material.dart';

import 'veiculos_page.dart';
import 'abastecimento_form_page.dart';
import 'abastecimentos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Abastecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Bem-vindo!', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VeiculosPage(),
                      ),
                    );
                  },
                  child: const Text('Meus veículos'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AbastecimentoFormPage(),
                      ),
                    );
                  },
                  child: const Text('Registrar abastecimento'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AbastecimentosPage(),
                      ),
                    );
                  },
                  child: const Text('Histórico de abastecimentos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
