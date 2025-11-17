import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool carregando = false;

  Future<void> fazerLogin() async {
    try {
      setState(() => carregando = true);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao fazer login: $e")));
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔵 FUNDO DO FUSCA
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
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "E-mail"),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: senhaController,
                    decoration: const InputDecoration(labelText: "Senha"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity, // botão ocupando a largura toda
                    child: ElevatedButton(
                      onPressed: carregando ? null : fazerLogin,
                      child: carregando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Entrar"),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text("Criar uma conta"),
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
