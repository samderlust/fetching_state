library fetching_state;

import 'package:flutter/material.dart';

/// The predefined states when fetching data
enum FetchingStatus { init, loading, done, error }

/// FetchingState allow you to handle UI base on the current state of data fetching
class FetchingState<T, E> {
  /// fetching status [FetchingStatus]
  final FetchingStatus fetchingStatus;

  /// data that pass to `onDone`
  ///
  /// useage: `FetchingState.done({T? data})`
  final T? data;

  /// data that pass to `onError`
  ///
  /// useage: `FetchingState.error({E? error})`
  final E? error;

  FetchingState({
    this.data,
    this.error,
    required this.fetchingStatus,
  });

  FetchingState copyWith({
    required FetchingStatus fetchingStatus,
  }) {
    return FetchingState(
      fetchingStatus: fetchingStatus,
    );
  }

  /// Create new FetchingState instance, default status to [FetchingStatus.init]
  factory FetchingState.init() =>
      FetchingState(fetchingStatus: FetchingStatus.init);

  /// Create new FetchingState instance, default status to [FetchingStatus.loading]
  factory FetchingState.loading() =>
      FetchingState(fetchingStatus: FetchingStatus.loading);

  /// Create new FetchingState instance, default status to [FetchingStatus.done]
  factory FetchingState.done({T? data}) =>
      FetchingState(fetchingStatus: FetchingStatus.done, data: data);

  /// Create new FetchingState instance, default status to [FetchingStatus.error]
  factory FetchingState.error({E? error}) =>
      FetchingState(fetchingStatus: FetchingStatus.error, error: error);

  /// Declare what which Widget should be return base on [fetchingStatus]
  ///
  /// Allow to skip some method that you don't need or some methods return a same widget,  use [orElse] instead
  Widget whenOrElse({
    Widget Function()? onLoading,
    Widget Function(T? data)? onDone,
    Widget Function(E? error)? onError,
    Widget Function()? onInit,
    required Widget Function()? orElse,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.init:
        return onInit == null ? orElse!() : onInit();
      case FetchingStatus.loading:
        return onLoading == null ? orElse!() : onLoading();
      case FetchingStatus.done:
        return onDone == null ? orElse!() : onDone(data);
      case FetchingStatus.error:
        return onError == null ? orElse!() : onError(error);
      default:
        return orElse!();
    }
  }

  /// Declare which Widget should be return base on [fetchingStatus]
  ///
  /// all state methods are required
  Widget when({
    required Widget Function() onLoading,
    required Widget Function(T? data) onDone,
    required Widget Function(E? error) onError,
    required Widget Function() onInit,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.init:
        return onInit();
      case FetchingStatus.loading:
        return onLoading();
      case FetchingStatus.done:
        return onDone(data);
      case FetchingStatus.error:
        return onError(error);
    }
  }

  /// Shortcurt for checking if current status is done
  bool get isDone => fetchingStatus == FetchingStatus.done;

  /// Shortcurt for checking if current status is init
  bool get isInit => fetchingStatus == FetchingStatus.init;

  /// Shortcurt for checking if current status is loading
  bool get isLoading => fetchingStatus == FetchingStatus.loading;

  /// Shortcurt for checking if current status is error
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
