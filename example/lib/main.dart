import 'package:flutter/material.dart';

import 'package:fetching_state/fetching_state.dart';

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
      title: 'Fetching State FetchingStateExample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const FetchingStateExample(),
    );
  }
}

class FetchingStateExample extends StatefulWidget {
  const FetchingStateExample({Key? key}) : super(key: key);

  @override
  _FetchingStateExampleState createState() => _FetchingStateExampleState();
}

class _FetchingStateExampleState extends State<FetchingStateExample> {
  late FetchingState<String?> _fetching;
  @override
  void initState() {
    _fetching = FetchingState.init(data: null);
    super.initState();
  }

  Future<void> getDone() async {
    setState(() {
      _fetching = _fetching.copyWhenLoading();
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _fetching = _fetching.copyWhenDone(data: 'DONE IN STATE');
    });
  }

  Future<void> loadMoreText() async {
    setState(() {
      _fetching = _fetching.copyWhenLoadingMore();
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (_fetching.data == null) {
      setState(() {
        _fetching = _fetching.copyWhenError(error: 'No current data');
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
      _fetching = _fetching.copyWhenLoadingMore();
    });
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _fetching = _fetching.copyWhenError(error: 'Error IN STATE');
    });
  }

  Future<void> getInit() async {
    setState(() {
      _fetching = _fetching.copyWhenLoadingMore();
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
            const Spacer(),
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
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              height: 60,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const LoadStatusExample()),
                  );
                },
                child: const Text('Load Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// I know this is a lame example.
// But hope it'll give you an idea of how of this mixin works
class Counter with LoadStatusMixin {
  final int value;

  Counter(this.value);

  Counter copyWith({int? value}) {
    return Counter(value ?? this.value);
  }
}

class LoadStatusExample extends StatefulWidget {
  const LoadStatusExample({Key? key}) : super(key: key);

  @override
  State<LoadStatusExample> createState() => _LoadStatusExampleState();
}

class _LoadStatusExampleState extends State<LoadStatusExample> {
  Counter _counter = Counter(1);

  void increase() async {
    setState(() {
      _counter.setLoadStatusLoading();
    });

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _counter = _counter.copyWith(value: _counter.value + 1);
      _counter.setLoadStatusDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Status Example'),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Builder(
              builder: (context) {
                return _counter.whenOrElse(
                  onLoading: () => const CircularProgressIndicator(),
                  onDone: (_) => Text(_counter.value.toString()),
                  onInit: () => const Text('Init'),
                  onError: () => const Text('Error'),
                  orElse: () => const Text('Nothing'),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: increase,
              child: const Text('Add'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
