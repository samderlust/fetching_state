library fetching_state;

import 'package:flutter/material.dart';

enum FetchingStatus { init, loading, done, error }

class FetchingState<T, E> {
  final FetchingStatus fetchingStatus;
  final T? data;
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

  factory FetchingState.init() =>
      FetchingState(fetchingStatus: FetchingStatus.init);
  factory FetchingState.loading() =>
      FetchingState(fetchingStatus: FetchingStatus.loading);
  factory FetchingState.done({T? data}) =>
      FetchingState(fetchingStatus: FetchingStatus.done, data: data);
  factory FetchingState.error({E? error}) =>
      FetchingState(fetchingStatus: FetchingStatus.error, error: error);

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchingState && other.fetchingStatus == fetchingStatus;
  }

  @override
  int get hashCode => fetchingStatus.hashCode;

  @override
  String toString() => 'FetchingState(fetchingStatus: $fetchingStatus)';
}
