import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'veiculos_page.dart';
import 'abastecimento_form_page.dart';
import 'abastecimentos_page.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔵 FUSCA NO FUNDO
        Positioned.fill(
          child: Opacity(
            opacity: 0.06,
            child: SvgPicture.asset(
              'assets/images/fusca.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),

        /// 🔵 CONTEÚDO DA TELA
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text("Controle de Abastecimento")),

          /// 🔵 DRAWER DO MENU
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF597A9A), // sua cor escura da paleta
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/fusca.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      height: 80,
                    ),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: const Text("Meus veículos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VeiculosPage()),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.local_gas_station),
                  title: const Text("Registrar abastecimento"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AbastecimentoFormPage(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text("Histórico de abastecimentos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AbastecimentosPage(),
                      ),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sair"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bem-vindo!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VeiculosPage()),
                      );
                    },
                    child: const Text("Meus veículos"),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AbastecimentoFormPage(),
                        ),
                      );
                    },
                    child: const Text("Registrar abastecimento"),
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AbastecimentosPage(),
                        ),
                      );
                    },
                    child: const Text("Histórico de abastecimentos"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
