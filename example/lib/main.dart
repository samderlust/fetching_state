import 'package:fetching_state/fetching_state.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetchin State Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late FetchingState<String, String> _fetching;
  @override
  void initState() {
    _fetching = FetchingState.init();
    super.initState();
  }

  Future<void> getDone() async {
    setState(() {
      _fetching = FetchingState.loading();
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _fetching = FetchingState.done(data: 'DONE IN STATE');
    });
  }

  Future<void> getError() async {
    setState(() {
      _fetching = FetchingState.loading();
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _fetching = FetchingState.error(error: 'Error IN STATE');
    });
  }

  Future<void> getInit() async {
    setState(() {
      _fetching = FetchingState.loading();
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _fetching = FetchingState.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Builder(
                builder: (context) {
                  return _fetching.when<Widget>(
                    onInit: () => const Text(
                      'INIT',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onDone: (text) => Text(
                      text!,
                      style: const TextStyle(color: Colors.green),
                    ),
                    onError: (error) => Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onLoading: () => const CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: getDone,
              child: const Text('Done'),
            ),
            ElevatedButton(
              onPressed: getError,
              child: const Text('Error'),
            ),
            ElevatedButton(
              onPressed: getInit,
              child: const Text('Init'),
            ),
          ],
        ),
      ),
    );
  }
}
