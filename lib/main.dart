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
      ], child: const MyHomePage(title: 'Counter with BlocSelector')),
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
            BlocSelector<CounterBloc, int, bool>(
              selector: (state) {
                print('Selector: ${state.isEven}');
                return state.isEven ? true : false;
              },
              builder: (context, stateIsEven) {
                return BlocConsumer<CounterBloc, int>(
                  builder: (context, state) {
                    print('Builder-stateIsEven: $stateIsEven');
                    return Text(
                      '$state',
                      style: stateIsEven
                          ? Theme.of(context).textTheme.headline4
                          : Theme.of(context).textTheme.headline6,
                    );
                  },
                  listener: (context, state) {
                    // really interesting phenomenon here; stateIsEven inside
                    // this listener actually returns the previous value!!!
                    print('Listener-stateIsEven: $stateIsEven');
                  },
                );
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
