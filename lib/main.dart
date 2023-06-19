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
      home: MultiBlocProvider(providers: [
        BlocProvider(
          create: (_) => CounterBloc(0),
        )
      ], child: const MyHomePage(title: 'Counter with Bloc/multi-event')),
    );
  }
}

class CounterEvent {
} // kinda abstract; intended to be subclassed so we can have multiple events

class CounterIncrementPressed extends CounterEvent {}

class CounterDecrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc(int initialCount) : super(initialCount) {
    on<CounterIncrementPressed>((event, emit) {
      emit(state + 1);
    });

    on<CounterDecrementPressed>((event, emit) {
      emit(state - 1);
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
            BlocConsumer<CounterBloc, int>(
              buildWhen: (previousState, currentState) => currentState >= 0,
              builder: (context, state) {
                return Text(
                  '$state',
                  style: state % 2 == 0
                      ? Theme.of(context).textTheme.headline4
                      : Theme.of(context).textTheme.headline1, // make odd numbers bigger
                );
              },
              listenWhen: (previousState, currentState) =>
                  currentState % 2 == 0,
              listener: (context, state) {
                print(state);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () =>
                context.read<CounterBloc>().add(CounterDecrementPressed()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () =>
                context.read<CounterBloc>().add(CounterIncrementPressed()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
