import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Counter with Cubit/Stream'),
    );
  }
}

class CounterCubit extends Cubit<int> {
  // by virtue of having this <int> notation, and
  // the super param of the same type (post-colon initializer list):
  // we magically have the *_state* variable
  CounterCubit(int initialCount) : super(initialCount) {
    emitInitialState(); // TODO: make this work first
  }
  void emitInitialState() => emit(state); // TODO: make this work first

  // CounterCubit(int initialCount) : super(0); // super overrides our input
  // CounterCubit() : super(0); // constructor takes no params; hardcoding initial state

  void increment() => emit(state + 1); // state is just a getter for _state

}

/// We really want to use a StatefulWidget for performance reasons
/// We can use a Stateless and it'll work, but it's not ideal.
/// Read the docs on Stateless for a better idea.
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CounterCubit _counter = CounterCubit(0);

  @override
  void initState() {
    _counter.emitInitialState(); // TODO: fix this to work per docs
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<int>(
              stream: _counter.stream,
              // initialData: _counter.state,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: Theme.of(context).textTheme.headline4,
                );
              }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counter.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
