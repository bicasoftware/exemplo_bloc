import 'package:exemplo_bloc/src/bloc/bloc_main.dart';
import 'package:exemplo_bloc/view2.dart';
import 'package:flutter/material.dart';
import 'package:lib_observer/stream_observer.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///Aqui vc envelopa sua aplicação com seu bloc
    ///Mas você pode colocar qualquer widget dentro do provider
    return Provider<BlocMain>(
      ///no create, vc instancia seu bloc
      create: (_) => BlocMain(nome: "Teste", cidades: ['santos']),

      ///no dispose, vc precisa fechar todas as streams
      dispose: (_, BlocMain b) => b.dispose(),

      ///E no child, vc retorna seu MaterialApp normalmente
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final cidadeController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    ///Aqui você recupera o seu bloc usando o Provider
    final b = Provider.of<BlocMain>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo, Bloc"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),

            ///Adiciona nova cidade ao bloc
            onPressed: () => b.addCidade(cidadeController.text),
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextFormField(
                controller: cidadeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Adicionar cidade",
                  hintText: "Aracajú",
                ),
              ),

              ///Carrega o nome que está no Bloc
              StreamObserver<String>(
                stream: b.outNome,
                onSuccess: (_, String nome) => Text(nome),
              ),
              Expanded(
                ///Carrega lista de cidades que está no Bloc
                child: StreamObserver<List<String>>(
                  stream: b.outCidades,
                  onSuccess: (_, List<String> cidades) {
                    return ListView.builder(
                      itemCount: cidades.length,
                      itemBuilder: (_, int i) => ListTile(
                        onTap: () => print(cidades[i]),
                        leading: Icon(Icons.place),
                        title: Text(cidades[i]),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_sweep),

                          ///Chama metodo para remover a cidade
                          onPressed: () => b.removeCidade(i),
                        ),
                      ),
                    );
                  },
                ),
              ),
              MaterialButton(
                child: Text("Ir para tela 2"),
                color: Colors.teal,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => View2(),
                    fullscreenDialog: true,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
