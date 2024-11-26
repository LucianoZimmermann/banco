import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'entity/Investimento.dart';
import 'service/InvestimentoService.dart';

// Função principal que inicia o aplicativo
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que a inicialização do Flutter esteja concluída
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializa o Firebase
  runApp(const MyApp()); // Executa o aplicativo MyApp
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Investimentos',
      theme: ThemeData(
        // Paleta de cores mais visível com contraste aprimorado
        primaryColor: const Color(0xFF512DA8), // Roxo mais escuro
        colorScheme: ColorScheme(
          primary: const Color(0xFF512DA8), // Roxo escuro
          secondary: const Color(0xFF9575CD), // Roxo mais claro
          surface: const Color(0xFFFFFFFF), // Branco
          background: const Color(0xFFF3E5F5), // Lavanda mais clara
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const InvestimentoListScreen(),
    );
  }
}

// Tela que exibe a lista de investimentos
class InvestimentoListScreen extends StatefulWidget {
  const InvestimentoListScreen({super.key});

  @override
  State<InvestimentoListScreen> createState() => _InvestimentoListScreenState();
}

// Estado da tela de lista de investimentos
class _InvestimentoListScreenState extends State<InvestimentoListScreen> {
  final InvestimentoService _service = InvestimentoService(); // Instância do serviço de investimentos

  // Método para adicionar um novo investimento
  void _addInvestimento() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InvestimentoFormScreen()), // Navega para a tela de formulário
    );
  }

  // Método para editar um investimento existente
  void _editInvestimento(Investimento investimento) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InvestimentoFormScreen(investimento: investimento)), // Navega para a tela de edição
    );
  }

  // Método para excluir um investimento
  void _deleteInvestimento(String id) {
    _service.deleteInvestimento(id); // Chama o serviço para excluir o investimento
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Investimentos'), // Título da AppBar
      ),
      body: StreamBuilder<List<Investimento>>(
        stream: _service.getInvestimentos(), // seu método Stream para obter os dados
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'), // Exibe mensagem de erro caso tenha
            );
          }
          if (snapshot.hasData) {
            final investimentos = snapshot.data!;
            return ListView.builder(
              itemCount: investimentos.length,
              itemBuilder: (context, index) {
                final investimento = investimentos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          investimento.nome,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(investimento.descricao, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Tipo da Moeda: ${investimento.tipoMoeda}'),
                        Text('Valor da Moeda: ${investimento.valorMoeda}'),
                        Text('Preço Atual: ${investimento.precoAtual}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addInvestimento, // Chama o método para adicionar um investimento
        child: const Icon(Icons.add), // Ícone do botão flutuante
        tooltip: 'Adicionar Investimento', // Dica do botão
      ),
    );
  }
}

// Tela para adicionar ou editar um investimento
class InvestimentoFormScreen extends StatefulWidget {
  final Investimento? investimento; // Recebe um investimento para edição, se houver
  const InvestimentoFormScreen({super.key, this.investimento});

  @override
  State<InvestimentoFormScreen> createState() => _InvestimentoFormScreenState();
}

// Estado da tela de formulário de investimento
class _InvestimentoFormScreenState extends State<InvestimentoFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário
  final TextEditingController _nomeController = TextEditingController(); // Controlador para o campo nome
  final TextEditingController _descricaoController = TextEditingController(); // Controlador para o campo descrição
  final TextEditingController _tipoMoedaController = TextEditingController(); // Controlador para o campo tipo da moeda
  final TextEditingController _valorMoedaController = TextEditingController(); // Controlador para o campo valor da moeda
  final TextEditingController _precoAtualController = TextEditingController(); // Controlador para o campo preço atual
  final InvestimentoService _service = InvestimentoService(); // Instância do serviço de investimentos

  @override
  void initState() {
    super.initState();
    // Se um investimento é passado, preenche os campos do formulário com seus dados
    if (widget.investimento != null) {
      _nomeController.text = widget.investimento!.nome;
      _descricaoController.text = widget.investimento!.descricao;
      _tipoMoedaController.text = widget.investimento!.tipoMoeda;
      _valorMoedaController.text = widget.investimento!.valorMoeda.toString();
      _precoAtualController.text = widget.investimento!.precoAtual.toString();
    }
  }

  // Método para salvar o investimento
  void _saveInvestimento() {
    if (_formKey.currentState!.validate()) {
      try {
        final nome = _nomeController.text;
        final descricao = _descricaoController.text;
        final tipoMoeda = _tipoMoedaController.text;
        final valorMoeda = double.tryParse(_valorMoedaController.text) ?? 0.0;
        final precoAtual = double.tryParse(_precoAtualController.text) ?? 0.0;

        if (valorMoeda <= 0 || precoAtual <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Valores devem ser positivos')),
          );
          return;
        }

        final id = widget.investimento?.id ?? DateTime.now().toString();
        final investimento = Investimento(
          id: id,
          nome: nome,
          descricao: descricao,
          tipoMoeda: tipoMoeda,
          valorMoeda: valorMoeda,
          precoAtual: precoAtual,
        );

        _service.saveInvestimento(investimento);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário de Investimento')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              TextFormField(
                controller: _tipoMoedaController,
                decoration: const InputDecoration(labelText: 'Tipo da Moeda'),
                validator: (value) => value!.isEmpty ? 'Informe o tipo da moeda' : null,
              ),
              TextFormField(
                controller: _valorMoedaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor da Moeda'),
                validator: (value) => value!.isEmpty ? 'Informe o valor da moeda' : null,
              ),
              TextFormField(
                controller: _precoAtualController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Preço Atual'),
                validator: (value) => value!.isEmpty ? 'Informe o preço atual' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInvestimento,
                child: const Text('Salvar Investimento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
