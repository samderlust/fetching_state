# Fetching State

A small package that helps easily to work with UI changes base on the state of fetching remote data

## Table of content

1.  [FetchingState](#fetchingstate)
2.  [LoadStatus](#loadstatus)
3.  [LoadingState](#loadingstate)

## Features

- Get rid of `if` `else` statements in UI when state change. Hence, cleaner UI code
- Decide what to display when fetching remote data in 4 states `[init, loading,done, error, loadingMore]`
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

### <a name="fetchingstate"></a>1. FetchingState

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
    if (_fetching.value == null) {
      setState(() {
        _fetching = FetchingState.error('No current data');
      });
      return;
    }

    setState(() {
      _fetching = FetchingState.loadMore(_fetching.value);
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _fetching = FetchingState.done('${_fetching.value} - extra text');
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
      _fetching = FetchingState.init();
    });
  }
```

### 1.2 capture change in UI

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
```

### <a name="loadstatus"></a>2. LoadStatus

declare a class with `LoadStatus` mixin

```
class Counter with LoadStatusMixin {
  final int value;

  Counter(this.value);

  Counter copyWith({int? value}) {
    return Counter(value ?? this.value);
  }
}
```

manipulate state

```

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
```

UI implement:

```
  return _counter.whenOrElse(
      onLoading: () => const CircularProgressIndicator(),
      onDone: (_) => Text(_counter.value.toString()),
      onInit: () => const Text('Init'),
      onError: () => const Text('Error'),
      orElse: () => const Text('Nothing'),
    );
```

### <a name="loadingstate"></a>3. LoadingState

similar to [FetchingState] but not data object required. Use when you just need plain status of the job.

## Appreciate Your Feedbacks

If you find anything need to be improve or want to request a feature. Please go ahead and create an issue in the [Github](https://github.com/samderlust/fetching_state) repo
