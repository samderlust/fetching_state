<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Fetching State

A small package that helps easily to work with UI changes base on the state of fetching remote data

## Features

- Get rid of `if` `else` statements in UI
- Decide what to display when fetching remote data in 4 states [`init`, `loading`,`done`, `error`]
- Option to pass the data or error objects in `onDone` and `onError`

## Getting started

## Installing the library:

Like any other package, add the library to your pubspec.yaml dependencies:

```
dependencies:
    fetching_state:
```

Then import it wherever you want to use it:

```
import 'package:fetching_state/fetching_state.dart';
```

## Usage

see full example in `example` folder

```
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

          ],
        ),
      ),
    );
  }
}
```

## Appreciate Your Feedbacks

If you find anything need to be improve or want to request a feature. Please go ahead and create an issue in the [Github](https://github.com/samderlust/fetching_state) repo
