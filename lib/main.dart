import 'package:flutter/material.dart';

void main() {
  runApp(ListaDeCompras());
}

class Item {
  String nome;
  String categoria;
  double precoMaximo;

  Item(
      {required this.nome, required this.categoria, required this.precoMaximo});
}

class ListaDeCompras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
// Adiciona a imagem do logo
                Image.asset(
                  'img/logo.png',
                  height: 244,
                  width: 275,
                ),
              ],
            ),
            SizedBox(
              height: 20,
              child: const DecoratedBox(
                decoration: const BoxDecoration(color: Colors.green),
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuário',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
// Verificar credenciais
                if (_usernameController.text == 'Usuario' &&
                    _passwordController.text == 'senha123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShoppingListPage()),
                  );
                } else {
// Exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Credenciais inválidas')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 140, 209, 143),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text('Luana Gabrielly')
          ],
        ),
      ),
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
// Lista de itens (simulando um banco de dados)
  List<Item> items = [];

  final List<String> categoriasValidas = [
    'Alimentos',
    'Limpeza',
    'Higiene',
    'Bebidas'
  ];

  void _adicionarItem(Item item) {
    setState(() {
      items.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item adicionado')),
    );
  }

  void _editarItem(int index, Item item) {
    setState(() {
      items[index] = item;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item atualizado')),
    );
  }

  void _removerItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item removido')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listinha'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].nome),
            subtitle: Text(
                '${items[index].categoria} R\$${items[index].precoMaximo.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _removerItem(index);
              },
            ),
            onTap: () async {
              Item? updatedItem = await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController _nomeController =
                      TextEditingController(text: items[index].nome);
                  TextEditingController _categoriaController =
                      TextEditingController(text: items[index].categoria);
                  TextEditingController _precoController =
                      TextEditingController(
                          text: items[index].precoMaximo.toString());
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 140, 209, 143),
                    title: Text('Editar Item',
                        style: TextStyle(color: Colors.white)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nomeController,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: _categoriaController,
                          decoration: InputDecoration(labelText: 'Categoria'),
                        ),
                        TextField(
                          controller: _precoController,
                          decoration:
                              InputDecoration(labelText: 'Preço Máximo'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_nomeController.text.isNotEmpty &&
                              _categoriaController.text.isNotEmpty &&
                              categoriasValidas
                                  .contains(_categoriaController.text) &&
                              double.tryParse(_precoController.text) != null) {
                            Navigator.pop(
                              context,
                              Item(
                                nome: _nomeController.text.trim(),
                                categoria: _categoriaController.text.trim(),
                                precoMaximo:
                                    double.parse(_precoController.text.trim()),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Preencha todos os campos corretamente')),
                            );
                          }
                        },
                        child: Text('Salvar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );

              if (updatedItem != null) {
                _editarItem(index, updatedItem);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.green,
        backgroundColor: const Color.fromARGB(255, 140, 209, 143),
        onPressed: () async {
          Item? newItem = await showDialog(
            context: context,
            builder: (context) {
              TextEditingController _nomeController = TextEditingController();
              TextEditingController _categoriaController =
                  TextEditingController();
              TextEditingController _precoController = TextEditingController();

              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 140, 209, 143),
                title: Text('Novo Item', style: TextStyle(color: Colors.white)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: _categoriaController,
                      decoration: InputDecoration(labelText: 'Categoria'),
                    ),
                    TextField(
                      controller: _precoController,
                      decoration: InputDecoration(labelText: 'Preço Máximo'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text('Cancelar', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_nomeController.text.isNotEmpty &&
                          _categoriaController.text.isNotEmpty &&
                          categoriasValidas
                              .contains(_categoriaController.text) &&
                          double.tryParse(_precoController.text) != null) {
                        Navigator.pop(
                          context,
                          Item(
                            nome: _nomeController.text.trim(),
                            categoria: _categoriaController.text.trim(),
                            precoMaximo:
                                double.parse(_precoController.text.trim()),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Preencha todos os campos corretamente')),
                        );
                      }
                    },
                    child: Text('Adicionar',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );

          if (newItem != null) {
            _adicionarItem(newItem);
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
