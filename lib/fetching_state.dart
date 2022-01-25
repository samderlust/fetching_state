library fetching_state;

import 'package:flutter/material.dart';

enum FetchingStatus { INIT, LOADING, DONE, ERROR }

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
      FetchingState(fetchingStatus: FetchingStatus.INIT);
  factory FetchingState.loading() =>
      FetchingState(fetchingStatus: FetchingStatus.LOADING);
  factory FetchingState.done(T data) =>
      FetchingState(fetchingStatus: FetchingStatus.DONE, data: data);
  factory FetchingState.error(E error) =>
      FetchingState(fetchingStatus: FetchingStatus.ERROR, error: error);

  Widget when({
    Widget Function()? onLoading,
    Widget Function(T? data)? onDone,
    Widget Function(E? error)? onError,
    Widget Function()? onInit,
    required Widget Function() orElse,
  }) {
    switch (fetchingStatus) {
      case FetchingStatus.INIT:
        return onInit == null ? orElse() : onInit();
      case FetchingStatus.LOADING:
        return onLoading == null ? orElse() : onLoading();
      case FetchingStatus.DONE:
        return onDone == null ? orElse() : onDone(data);
      case FetchingStatus.ERROR:
        return onError == null ? orElse() : onError(error);
      default:
        return orElse();
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
