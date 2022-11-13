import 'enums.dart';

/// FetchingState allow you to handle UI base on the current state of data fetching
class FetchingState<T> {
  /// fetching status [LoadState]
  final LoadState fetchingStatus;

  /// data that pass to `onDone`
  ///
  /// usage: `FetchingState.done({T? data})`
  final T? data;

  /// data that pass to `onError`
  ///
  /// usage: `FetchingState.error({Object? error})`
  final Object? error;

  FetchingState({
    this.data,
    this.error,
    required this.fetchingStatus,
  });

  FetchingState<T> copyWith({
    required LoadState fetchingStatus,
    T? data,
    Object? error,
  }) {
    return FetchingState(
      fetchingStatus: fetchingStatus,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  /// create new instance of FetchingState.
  /// set status to [LoadState.loading]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this is helpful when you want to add more data into current [data]
  FetchingState<T> copyWhenLoading() {
    return FetchingState(
      fetchingStatus: LoadState.loading,
      data: data,
    );
  }

  /// create new instance of FetchingState.
  /// set status to [LoadState.loadingMore]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this is helpful when you want to add more data into current [data]
  FetchingState<T> copyWhenLoadingMore() {
    return FetchingState(
      fetchingStatus: LoadState.loadingMore,
      data: data,
    );
  }

  /// create new instance of FetchingState.
  /// set status to [LoadState.done]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this method should be use after loading more item into data
  FetchingState<T> copyWhenDone({
    T? data,
  }) {
    return FetchingState(
      fetchingStatus: LoadState.done,
      data: data ?? this.data,
    );
  }

  /// create new instance of FetchingState.
  /// set status to [LoadState.error]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this method should be use after loading more item into data
  FetchingState<T> copyWhenError({
    T? data,
    Object? error,
  }) {
    return FetchingState(
        fetchingStatus: LoadState.error, error: error, data: data ?? this.data);
  }

  /// Create new FetchingState instance, default status to [LoadState.init]
  factory FetchingState.init({required T data, Object? error}) => FetchingState(
        fetchingStatus: LoadState.init,
        data: data,
        error: error,
      );

  /// Create new FetchingState instance, default status to [LoadState.loading]
  factory FetchingState.loading() =>
      FetchingState(fetchingStatus: LoadState.loading);

  /// Create new FetchingState instance, default status to [LoadState.done]
  factory FetchingState.done([T? data]) =>
      FetchingState(fetchingStatus: LoadState.done, data: data);

  /// Create new FetchingState instance, default status to [LoadState.error]
  factory FetchingState.error([Object? error]) =>
      FetchingState(fetchingStatus: LoadState.error, error: error);

  /// Declare methods that return widgets base on [fetchingStatus]
  ///
  /// Allow to use [orElse], skip some methods that you don't need.
  R whenOrElse<R>({
    R Function()? onLoading,
    R Function(T? data, bool isLoadingMore)? onDone,
    R Function(Object? error)? onError,
    R Function()? onInit,
    required R Function()? orElse,
  }) {
    switch (fetchingStatus) {
      case LoadState.init:
        return onInit == null ? orElse!() : onInit();
      case LoadState.loading:
        return onLoading == null ? orElse!() : onLoading();
      case LoadState.loadingMore:
      case LoadState.done:
        return onDone == null ? orElse!() : onDone(data, isLoadingMore);
      case LoadState.error:
        return onError == null ? orElse!() : onError(error);
      default:
        return orElse!();
    }
  }

  /// Declare methods base on [fetchingStatus] that return widgets
  ///
  /// all state methods are required
  R when<R>({
    required R Function() onLoading,
    required R Function(T? data, bool isLoadingMore) onDone,
    required R Function(Object? error) onError,
    required R Function() onInit,
    // required Widget Function(T? data, bool isLoadMore) onLoadMore,
  }) {
    switch (fetchingStatus) {
      case LoadState.init:
        return onInit();
      case LoadState.loading:
        return onLoading();
      case LoadState.done:
      case LoadState.loadingMore:
        return onDone(data, isLoadingMore);
      case LoadState.error:
        return onError(error);
    }
  }

  /// Shortcut for checking if current status is done
  bool get isDone => fetchingStatus == LoadState.done;

  /// Shortcut for checking if current status is init
  bool get isInit => fetchingStatus == LoadState.init;

  /// Shortcut for checking if current status is loading
  bool get isLoading => fetchingStatus == LoadState.loading;

  /// Shortcut for checking if current status is loading more data
  bool get isLoadingMore => fetchingStatus == LoadState.loadingMore;

  /// Shortcut for checking if current status is error
  bool get isError => fetchingStatus == LoadState.error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchingState && other.fetchingStatus == fetchingStatus;
  }

  @override
  int get hashCode => fetchingStatus.hashCode;

  @override
  String toString() =>
      'FetchingState(fetchingStatus: $fetchingStatus, data: $data, error: $error)';
}
