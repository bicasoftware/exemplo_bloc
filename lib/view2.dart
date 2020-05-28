import 'package:exemplo_bloc/src/bloc/bloc_main.dart';
import 'package:flutter/material.dart';
import 'package:lib_observer/stream_observer.dart';
import 'package:provider/provider.dart';

class View2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///Recupera novamente o bloc
    final b = Provider.of<BlocMain>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tela 2"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            ///Como o [nome] está dentro do seu bloc, vc pode carregar o mesmo valor por aqui
            StreamObserver<String>(
              stream: b.outNome,
              onSuccess: (_, String nome) => Text(nome),
            )
          ],
        ),
      ),
    );
  }
}
