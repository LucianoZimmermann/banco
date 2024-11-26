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
        stream: _service.getInvestimentos(), // Obtém a lista de investimentos em tempo real
        builder: (context, snapshot) {
          // Verifica o estado da conexão
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Mostra indicador de carregamento
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados')); // Exibe mensagem de erro
          }
          final investimentos = snapshot.data ?? []; // Obtém os investimentos ou uma lista vazia
          return ListView.builder(
            itemCount: investimentos.length, // Define o número de itens na lista
            itemBuilder: (context, index) {
              final investimento = investimentos[index]; // Obtém o investimento atual
              return ListTile(
                title: Text(investimento.nome), // Exibe o nome do investimento
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(investimento.descricao), // Exibe a descrição do investimento
                    Text('Tipo da Moeda: ${investimento.tipoMoeda}'), // Exibe o tipo da moeda
                    Text('Valor da Moeda: ${investimento.valorMoeda}'), // Exibe o valor da moeda
                    Text('Preço Atual: ${investimento.precoAtual}'), // Exibe o preço atual
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit), // Ícone de editar
                      onPressed: () => _editInvestimento(investimento), // Chama o método de edição
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete), // Ícone de excluir
                      onPressed: () => _deleteInvestimento(investimento.id), // Chama o método de exclusão
                    ),
                  ],
                ),
              );
            },
          );
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
    if (_formKey.currentState!.validate()) { // Valida o formulário
      final nome = _nomeController.text;
      final descricao = _descricaoController.text;
      final tipoMoeda = _tipoMoedaController.text;
      final valorMoeda = double.parse(_valorMoedaController.text); // Converte o valor da moeda para double
      final precoAtual = double.parse(_precoAtualController.text); // Converte o preço atual para double
      final id = widget.investimento?.id ?? DateTime.now().toString(); // Usa o ID existente ou gera um novo
      final investimento = Investimento(
        id: id,
        nome: nome,
        descricao: descricao,
        tipoMoeda: tipoMoeda,
        valorMoeda: valorMoeda,
        precoAtual: precoAtual,
      );

      // Adiciona ou atualiza o investimento no serviço
      _service.saveInvestimento(investimento);
      Navigator.pop(context); // Retorna à tela anterior
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
                decoration: const InputDecoration(labelText: 'Valor da Moeda'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o valor da moeda' : null,
              ),
              TextFormField(
                controller: _precoAtualController,
                decoration: const InputDecoration(labelText: 'Preço Atual'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o preço atual' : null,
              ),
              const SizedBox(height: 20), // Espaço entre os campos e o botão
              ElevatedButton(
                onPressed: _saveInvestimento, // Chama o método para salvar o investimento
                child: const Text('Salvar'), // Texto do botão
              ),
            ],
          ),
        ),
      ),
    );
  }
}
