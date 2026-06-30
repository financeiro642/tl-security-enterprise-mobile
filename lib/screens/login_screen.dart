import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final user = TextEditingController(text: 'relatorio');
  final pass = TextEditingController(text: '153280');
  bool loading = false;
  String? error;

  Future<void> doLogin() async {
    setState(() { loading = true; error = null; });
    try {
      final ok = await ApiService().login(user.text.trim(), pass.text.trim());
      if (!mounted) return;
      if (ok) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logged', true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        setState(() => error = 'Usuário ou senha inválido');
      }
    } catch (_) {
      setState(() => error = 'Falha ao conectar na API');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors:[Color(0xFF07111F), Color(0xFF0A2A57)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const Icon(Icons.shield, color: Color(0xFF2F80FF), size: 96),
                const SizedBox(height: 16),
                const Text('TL SECURITY', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const Text('ENTERPRISE', style: TextStyle(fontSize: 24, color: Color(0xFF2F80FF), letterSpacing: 5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Monitoramento Inteligente', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 40),
                TextField(controller: user, decoration: const InputDecoration(labelText: 'Usuário', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder())),
                if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: loading ? null : doLogin, child: loading ? const CircularProgressIndicator() : const Text('ENTRAR'))),
                const SizedBox(height: 50),
                const Text('Versão 1.0.0', style: TextStyle(color: Colors.white38)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
