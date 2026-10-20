import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ConfiguracoesLeituraApp());
}

class ConfiguracoesLeituraApp extends StatelessWidget {
  const ConfiguracoesLeituraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaLeitura(),
    );
  }
}

class TelaLeitura extends StatefulWidget {
  const TelaLeitura({super.key});

  @override
  State<TelaLeitura> createState() => _TelaLeituraState();
}

class _TelaLeituraState extends State<TelaLeitura> {
  bool temaEscuro = false;
  double tamanhoFonte = 18.0;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      temaEscuro = prefs.getBool('leitura.temaEscuro') ?? false;
      tamanhoFonte = prefs.getDouble('leitura.tamanhoFonte') ?? 18.0;
    });
  }

  Future<void> _salvarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('leitura.temaEscuro', temaEscuro);
    await prefs.setDouble('leitura.tamanhoFonte', tamanhoFonte);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferências salvas com sucesso!')),
      );
    }
  }

  Future<void> _restaurarPadrao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('leitura.temaEscuro');
    await prefs.remove('leitura.tamanhoFonte');

    setState(() {
      temaEscuro = false;
      tamanhoFonte = 18.0;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Padrão restaurado para os valores iniciais.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final corFundo = temaEscuro ? Colors.grey[900] : Colors.white;
    final corTexto = temaEscuro ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        title: const Text('Ajustes de Leitura'),
        backgroundColor: temaEscuro ? Colors.black : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: temaEscuro ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'A leitura engrandece a alma. Ajuste o tema e o tamanho da fonte abaixo para encontrar a configuração mais confortável para os seus olhos. As alterações afetam esta prévia imediatamente, mas só serão definitivas após salvar.',
                  style: TextStyle(
                    fontSize: tamanhoFonte,
                    color: corTexto,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tema Escuro', style: TextStyle(color: corTexto, fontSize: 16)),
                Switch(
                  value: temaEscuro,
                  onChanged: (valor) {
                    setState(() {
                      temaEscuro = valor;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Tamanho da Fonte: ${tamanhoFonte.toInt()}',
              style: TextStyle(color: corTexto, fontSize: 16),
            ),
            Slider(
              value: tamanhoFonte,
              min: 14,
              max: 28,
              divisions: 7, 
              label: tamanhoFonte.toInt().toString(),
              onChanged: (valor) {
                setState(() {
                  tamanhoFonte = valor;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarPreferencias,
              child: const Text('Salvar Preferências'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _restaurarPadrao,
              style: OutlinedButton.styleFrom(
                foregroundColor: temaEscuro ? Colors.white : Colors.black,
              ),
              child: const Text('Restaurar Padrão'),
            ),
          ],
        ),
      ),
    );
  }
}