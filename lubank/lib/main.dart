import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'entity/Investimento.dart';
import 'service/InvestimentoService.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'key',
        appId: 'id',
        messagingSenderId: 'sendid',
        projectId: 'myapp',
        storageBucket: 'myapp-b9yt18.appspot.com',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Investimentos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const InvestimentoListScreen(),
    );
  }
}

class InvestimentoListScreen extends StatefulWidget {
  const InvestimentoListScreen({super.key});

  @override
  State<InvestimentoListScreen> createState() => _InvestimentoListScreenState();
}

class _InvestimentoListScreenState extends State<InvestimentoListScreen> {
  final InvestimentoService _service = InvestimentoService();

  void _addInvestimento() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvestimentoFormScreen()),
    );
  }

  void _editInvestimento(Investimento investimento) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InvestimentoFormScreen(investimento: investimento)),
    );
  }

  void _deleteInvestimento(String id) {
    _service.deleteInvestimento(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Investimentos'),
      ),
      body: StreamBuilder<List<Investimento>>(
        stream: _service.getInvestimentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          final investimentos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: investimentos.length,
            itemBuilder: (context, index) {
              final investimento = investimentos[index];
              return ListTile(
                title: Text(investimento.nome),
                subtitle: Text(investimento.descricao),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editInvestimento(investimento),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteInvestimento(investimento.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addInvestimento,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Investimento',
      ),
    );
  }
}

class InvestimentoFormScreen extends StatefulWidget {
  final Investimento? investimento;
  const InvestimentoFormScreen({super.key, this.investimento});

  @override
  State<InvestimentoFormScreen> createState() => _InvestimentoFormScreenState();
}

class _InvestimentoFormScreenState extends State<InvestimentoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final InvestimentoService _service = InvestimentoService();

  @override
  void initState() {
    super.initState();
    if (widget.investimento != null) {
      _nomeController.text = widget.investimento!.nome;
      _descricaoController.text = widget.investimento!.descricao;
    }
  }

  void _saveInvestimento() {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text;
      final descricao = _descricaoController.text;
      final id = widget.investimento?.id ?? DateTime.now().toString();
      final investimento = Investimento(id: id, nome: nome, descricao: descricao);

      if (widget.investimento == null) {
        _service.addInvestimento(investimento);
      } else {
        _service.updateInvestimento(investimento);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.investimento == null ? 'Adicionar Investimento' : 'Editar Investimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInvestimento,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
