library fetching_state;

import 'package:flutter/material.dart';

/// The predefined states when fetching data
enum FetchingStatus { init, loading, done, error, loadingMore }

/// FetchingState allow you to handle UI base on the current state of data fetching
class FetchingState<T> {
  /// fetching status [FetchingStatus]
  final FetchingStatus fetchingStatus;

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
    required FetchingStatus fetchingStatus,
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
  /// set status to [FetchingStatus.loadingMore]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this is helpful when you want to add more data into current [data]
  FetchingState<T> copyWhenLoadingMore() {
    return FetchingState(
      fetchingStatus: FetchingStatus.loadingMore,
      data: data,
    );
  }

  /// create new instance of FetchingState.
  /// set status to [FetchingStatus.done]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this method should be use after loading more item into data
  FetchingState<T> copyWhenDone({
    T? data,
  }) {
    return FetchingState(
      fetchingStatus: FetchingStatus.done,
      data: data ?? this.data,
    );
  }

  /// create new instance of FetchingState.
  /// set status to [FetchingStatus.error]
  /// keep the current [data] and [error] or user can pass in those parameter.
  /// this method should be use after loading more item into data
  FetchingState<T> copyWhenError({
    T? data,
    Object? error,
  }) {
    return FetchingState(
        fetchingStatus: FetchingStatus.error,
        error: error,
        data: data ?? this.data);
  }

  /// Create new FetchingState instance, default status to [FetchingStatus.init]
  factory FetchingState.init({T? data, Object? error}) => FetchingState(
        fetchingStatus: FetchingStatus.init,
        data: data,
        error: error,
      );

  /// Create new FetchingState instance, default status to [FetchingStatus.loading]
  factory FetchingState.loading() =>
      FetchingState(fetchingStatus: FetchingStatus.loading);

  /// Create new FetchingState instance, default status to [FetchingStatus.done]
  factory FetchingState.done([T? data]) =>
      FetchingState(fetchingStatus: FetchingStatus.done, data: data);

  /// Create new FetchingState instance, default status to [FetchingStatus.error]
  factory FetchingState.error([Object? error]) =>
      FetchingState(fetchingStatus: FetchingStatus.error, error: error);

  /// Declare methods that return widgets base on [fetchingStatus]
  ///
  /// Allow to use [orElse], skip some methods that you don't need.
  Widget whenOrElse({
    Widget Function()? onLoading,
    Widget Function(T? data, bool isLoadingMore)? onDone,
    Widget Function(Object? error)? onError,
    Widget Function()? onInit,
    required Widget Function()? orElse,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.init:
        return onInit == null ? orElse!() : onInit();
      case FetchingStatus.loading:
        return onLoading == null ? orElse!() : onLoading();
      case FetchingStatus.loadingMore:
      case FetchingStatus.done:
        return onDone == null ? orElse!() : onDone(data, isLoadingMore);
      case FetchingStatus.error:
        return onError == null ? orElse!() : onError(error);
      default:
        return orElse!();
    }
  }

  /// Declare methods base on [fetchingStatus] that return widgets
  ///
  /// all state methods are required
  Widget when({
    required Widget Function() onLoading,
    required Widget Function(T? data, bool isLoadingMore) onDone,
    required Widget Function(Object? error) onError,
    required Widget Function() onInit,
    // required Widget Function(T? data, bool isLoadMore) onLoadMore,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.init:
        return onInit();
      case FetchingStatus.loading:
        return onLoading();
      case FetchingStatus.done:
      case FetchingStatus.loadingMore:
        return onDone(data, isLoadingMore);
      case FetchingStatus.error:
        return onError(error);
    }
  }

  /// Declare methods that return [R] base on [fetchingStatus]
  ///
  /// Allow to use [orElse], skip some methods that you don't need.
  R mapOrElse<R>({
    R Function()? onLoading,
    R Function(T? data, bool isLoadingMore)? onDone,
    R Function(Object? error)? onError,
    R Function()? onInit,
    required R Function()? orElse,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.init:
        return onInit == null ? orElse!() : onInit();
      case FetchingStatus.loading:
        return onLoading == null ? orElse!() : onLoading();
      case FetchingStatus.loadingMore:
      case FetchingStatus.done:
        return onDone == null ? orElse!() : onDone(data, isLoadingMore);
      case FetchingStatus.error:
        return onError == null ? orElse!() : onError(error);
      default:
        return orElse!();
    }
  }

  /// Declare methods base on [fetchingStatus]
  ///
  /// all state methods are required
  /// return type [R] need to be the same on all methods
  R map<R>({
    required R Function() onLoading,
    required R Function(T? data, bool isLoadingMore) onDone,
    required R Function(Object? error) onError,
    required R Function() onInit,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.init:
        return onInit();
      case FetchingStatus.loading:
        return onLoading();
      case FetchingStatus.loadingMore:
      case FetchingStatus.done:
        return onDone(data, isLoadingMore);
      case FetchingStatus.error:
        return onError(error);
    }
  }

  /// Shortcut for checking if current status is done
  bool get isDone => fetchingStatus == FetchingStatus.done;

  /// Shortcut for checking if current status is init
  bool get isInit => fetchingStatus == FetchingStatus.init;

  /// Shortcut for checking if current status is loading
  bool get isLoading => fetchingStatus == FetchingStatus.loading;

  /// Shortcut for checking if current status is loading more data
  bool get isLoadingMore => fetchingStatus == FetchingStatus.loadingMore;

  /// Shortcut for checking if current status is error
  bool get isError => fetchingStatus == FetchingStatus.error;

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
