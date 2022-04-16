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
      title: 'Fetching State Example',
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
  late FetchingState<String> _fetching;
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
      _fetching = FetchingState.done('DONE IN STATE');
    });
  }

  Future<void> loadMoreText() async {
    setState(() {
      _fetching = _fetching.copyWithLoadingMore();
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (_fetching.data == null) {
      setState(() {
        _fetching = FetchingState.error('No current data');
      });
      return;
    }

    setState(() {
      _fetching =
          _fetching.copyWhenDone(data: '${_fetching.data} - extra text');
    });
  }

  Future<void> getError() async {
    setState(() {
      _fetching = FetchingState.loading();
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _fetching = FetchingState.error('Error IN STATE');
    });
  }

  Future<void> getInit() async {
    setState(() {
      _fetching = FetchingState.loading();
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _fetching = FetchingState.init(data: '');
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
                  return _fetching.when(
                    onInit: () => const Text(
                      'INIT',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onDone: (text, isLoadingMore) => Text(
                      '${text ?? ''} ${isLoadingMore ? '....' : ''}',
                      style: const TextStyle(color: Colors.green),
                    ),
                    onError: (error) => Text(
                      error!.toString(),
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
              onPressed: loadMoreText,
              child: const Text('Load more text'),
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
