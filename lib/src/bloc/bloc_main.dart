import 'package:exemplo_bloc/src/bloc/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class BlocMain with BaseBloc {
  BlocMain({
    String nome,
    List<String> cidades,
  }) {
    ///Ao inicializar o bloc, é uma boa já adicionar nos Sinks todos os valores que devem ser lidos no começo;
    _inNome.add(nome);
    _inCidades.add(cidades);

    ///Esse listen, adiciona um int ao _inCounter a cada vez que alguma coisa for alterada no _bhsCidades
    _bhsCidades.listen((List<String> list) {
      _bhsCounter.sink.add(list.length);
    });
  }

  final BehaviorSubject<String> _bhsNome = BehaviorSubject<String>();
  Stream<String> get outNome => _bhsNome.stream;
  Sink<String> get _inNome => _bhsNome.sink;

  final BehaviorSubject<List<String>> _bhsCidades = BehaviorSubject<List<String>>();
  Stream<List<String>> get outCidades => _bhsCidades.stream;
  Sink<List<String>> get _inCidades => _bhsCidades.sink;

  final BehaviorSubject<int> _bhsCounter = BehaviorSubject<int>();
  Stream<int> get outCounter => _bhsCounter.stream;

  @override
  void dispose() {
    ///É necessário fechar todas as Streams, por isso o método dispose()
    _bhsNome.close();
    _bhsCidades.close();
    _bhsCounter.close();
  }

  void setNome(String newNome) {
    ///adiciona novo nome ao Stream
    _inNome.add(newNome);
  }

  void addCidade(String newCidade) {
    ///Gera nova lista, com o novo valor e adiciona ao Stream
    final newList = [..._bhsCidades.value, newCidade];
    _inCidades.add(newList);
  }

  void removeCidade(int pos) {
    final newList = [..._bhsCidades.value]..removeAt(pos);
    _inCidades.add(newList);
  }
}
