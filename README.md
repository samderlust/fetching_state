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

- Get rid of `if` `else` statements in UI when state change. Hence, cleaner UI code
- Decide what to display when fetching remote data in 4 states [`init`, `loading`,`done`, `error`, `loadingMore`]
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

### changing state

```
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
```

### capture change in UI

```
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
```

## Appreciate Your Feedbacks

If you find anything need to be improve or want to request a feature. Please go ahead and create an issue in the [Github](https://github.com/samderlust/fetching_state) repo
