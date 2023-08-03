/// FetchingState allow you to handle UI base on the current state of data fetching
/// Use this one when you want to attach your data object into the state.

sealed class FetchingState<T> {
  factory FetchingState.done(T data) => _FetchingStateDone(data);
  factory FetchingState.loadMore(T data) => _FetchingStateLoadMore(data);
  factory FetchingState.init() => _FetchingStateInit();
  factory FetchingState.loading() => _FetchingStateLoading();
  factory FetchingState.error(Object error) => _FetchingStateError(error);
}

final class _FetchingStateDone<T> implements FetchingState<T> {
  final T data;

  _FetchingStateDone(this.data);
}

final class _FetchingStateLoadMore<T> implements FetchingState<T> {
  final T data;
  _FetchingStateLoadMore(this.data);
}

final class _FetchingStateInit<T> implements FetchingState<T> {
  const _FetchingStateInit();
}

final class _FetchingStateError<T> implements FetchingState<T> {
  final Object error;

  const _FetchingStateError(this.error);
}

final class _FetchingStateLoading<T> implements FetchingState<T> {
  const _FetchingStateLoading();
}

extension FetchingStateX<T> on FetchingState<T> {
  R when<R>({
    required R Function() onLoading,
    required R Function(T data, bool isMore) onDone,
    required R Function(Object error) onError,
    required R Function() onInit,
  }) {
    return switch (this) {
      _FetchingStateInit() => onInit(),
      _FetchingStateLoading() => onLoading(),
      _FetchingStateDone(:final data) => onDone(data, false),
      _FetchingStateLoadMore(:final data) => onDone(data, true),
      _FetchingStateError(:final error) => onError(error),
    };
  }

  R whenOrElse<R>({
    R Function()? onLoading,
    R Function(T data, {bool isMore})? onDone,
    R Function(
      Object error,
    )? onError,
    R Function()? onInit,
    required R Function() orElse,
  }) {
    return switch (this) {
      _FetchingStateInit() => onInit != null ? onInit() : orElse(),
      _FetchingStateLoading() => onLoading != null ? onLoading() : orElse(),
      _FetchingStateLoadMore(:final data) =>
        onDone != null ? onDone(data, isMore: true) : orElse(),
      _FetchingStateDone(:final data) =>
        onDone != null ? onDone(data) : orElse(),
      _FetchingStateError(:final error) =>
        onError != null ? onError(error) : orElse(),
    };
  }

  /// Shortcut for checking if current status is done
  bool get isDone => this is _FetchingStateDone;

  /// Shortcut for checking if current status is init
  bool get isInit => this is _FetchingStateInit;

  /// Shortcut for checking if current status is loading
  bool get isLoading => this is _FetchingStateLoading;

  /// Shortcut for checking if current status is loading more data
  bool get isLoadingMore => this is _FetchingStateLoadMore;

  /// Shortcut for checking if current status is error
  bool get isError => this is _FetchingStateError;

  T? get value => switch (this) {
        _FetchingStateDone(:final value) ||
        _FetchingStateLoadMore(:final value) =>
          value,
        _ => null,
      };
}
