import 'enums.dart';

/// LoadingState allow you to handle UI base on the current state of data fetching
class LoadingState {
  /// fetching status [LoadState]
  final LoadState fetchingStatus;

  /// data that pass to `onError`
  ///
  /// usage: `LoadingState.error({Object? error})`
  final Object? error;

  LoadingState({
    this.error,
    required this.fetchingStatus,
  });

  LoadingState copyWith({
    required LoadState fetchingStatus,
    Object? error,
  }) {
    return LoadingState(
      fetchingStatus: fetchingStatus,
      error: error ?? this.error,
    );
  }

  /// Create new LoadingState instance, default status to [LoadState.init]
  factory LoadingState.init() => LoadingState(fetchingStatus: LoadState.init);

  /// Create new LoadingState instance, default status to [LoadState.loading]
  factory LoadingState.loading() =>
      LoadingState(fetchingStatus: LoadState.loading);

  /// Create new LoadingState instance, default status to [LoadState.done]
  factory LoadingState.loadingMore() =>
      LoadingState(fetchingStatus: LoadState.loadingMore);

  /// Create new LoadingState instance, default status to [LoadState.done]
  factory LoadingState.done() => LoadingState(fetchingStatus: LoadState.done);

  /// Create new LoadingState instance, default status to [LoadState.error]
  factory LoadingState.error([Object? error]) =>
      LoadingState(fetchingStatus: LoadState.error, error: error);

  /// Declare methods that return widgets base on [fetchingStatus]
  ///
  /// Allow to use [orElse], skip some methods that you don't need.
  R whenOrElse<R>({
    R Function()? onLoading,
    R Function(bool isLoadingMore)? onDone,
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
        return onDone == null ? orElse!() : onDone(isLoadingMore);
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
    required R Function(bool isLoadingMore) onDone,
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
        return onDone(isLoadingMore);
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

    return other is LoadingState && other.fetchingStatus == fetchingStatus;
  }

  @override
  int get hashCode => fetchingStatus.hashCode;

  @override
  String toString() =>
      'LoadingState(fetchingStatus: $fetchingStatus, error: $error)';
}
