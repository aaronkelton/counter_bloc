import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
          create: (_) => CounterBloc(0),
          child: const MyHomePage(title: 'Counter with Bloc/single-event')),
    );
  }
}

// class CounterEvent {} // kinda abstract; intended to be subclassed
class CounterIncrementPressed {} // extends CounterEvent {} // our method moves up to its own class?
// you can totally not subclass your events, but your bloc will be limited to just the one!!!
class CounterBloc extends Bloc<CounterIncrementPressed, int> {
  CounterBloc(int initialCount) : super(initialCount) {
    // this 'on' thingy is a "Event Handler"
    on<CounterIncrementPressed>((event, emit) {
      emit(state + 1);
    });
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Counter:'),
            BlocBuilder<CounterBloc, int>(
              builder: (context, state) {
                return Text('$state',
                    style: Theme.of(context).textTheme.headline4);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterBloc>().add(CounterIncrementPressed()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
