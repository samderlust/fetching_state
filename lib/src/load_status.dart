part of '../fetching_state.dart';

enum _LoadStatusEnums { init, loading, done, error, loadingMore }

/// A mixin to use with classes that have to do with loading status.
/// This mixin will attach `loadStatus` attribute into that class along with it are many helper methods for easily checking and setting current `loadStatus`.
/// There are also helper methods to render widget or perform action base on current `loadStatus` (when, whenOrElse, map, mapOrElse)
mixin LoadStatusMixin {
  _LoadStatusEnums loadStatus = _LoadStatusEnums.init;
  void setLoadStatusInit() => loadStatus = _LoadStatusEnums.init;
  void setLoadStatusLoading() => loadStatus = _LoadStatusEnums.loading;
  void setLoadStatusLoadMore() => loadStatus = _LoadStatusEnums.loadingMore;
  void setLoadStatusDone() => loadStatus = _LoadStatusEnums.done;
  void setLoadStatusError() => loadStatus = _LoadStatusEnums.error;

  bool get isInit => loadStatus == _LoadStatusEnums.init;
  bool get isLoading => loadStatus == _LoadStatusEnums.loading;
  bool get isLoadMore => loadStatus == _LoadStatusEnums.loadingMore;
  bool get isDone => loadStatus == _LoadStatusEnums.done;
  bool get isError => loadStatus == _LoadStatusEnums.error;

  Widget whenOrElse({
    Widget Function()? onLoading,
    Widget Function(bool isLoadingMore)? onDone,
    Widget Function()? onError,
    Widget Function()? onInit,
    required Widget Function() orElse,
  }) {
    switch (loadStatus) {
      case _LoadStatusEnums.init:
        return onInit == null ? orElse() : onInit();
      case _LoadStatusEnums.loading:
        return onLoading == null ? orElse() : onLoading();
      case _LoadStatusEnums.loadingMore:
      case _LoadStatusEnums.done:
        return onDone == null
            ? orElse()
            : onDone(loadStatus == _LoadStatusEnums.loadingMore);
      case _LoadStatusEnums.error:
        return onError == null ? orElse() : onError();
      default:
        return orElse();
    }
  }

  Widget when({
    required Widget Function() onLoading,
    required Widget Function(bool isLoadingMore) onDone,
    required Widget Function() onError,
    required Widget Function() onInit,
  }) {
    switch (loadStatus) {
      case _LoadStatusEnums.init:
        return onInit();
      case _LoadStatusEnums.loading:
        return onLoading();
      case _LoadStatusEnums.loadingMore:
      case _LoadStatusEnums.done:
        return onDone(loadStatus == _LoadStatusEnums.loadingMore);
      case _LoadStatusEnums.error:
        return onError();
    }
  }

  R map<R>({
    required R Function() onLoading,
    required R Function(bool isLoadingMore) onDone,
    required R Function() onError,
    required R Function() onInit,
  }) {
    switch (loadStatus) {
      case _LoadStatusEnums.init:
        return onInit();
      case _LoadStatusEnums.loading:
        return onLoading();
      case _LoadStatusEnums.loadingMore:
      case _LoadStatusEnums.done:
        return onDone(loadStatus == _LoadStatusEnums.loadingMore);
      case _LoadStatusEnums.error:
        return onError();
    }
  }

  R mapOrElse<R>({
    R Function()? onLoading,
    R Function(bool isLoadingMore)? onDone,
    R Function()? onError,
    R Function()? onInit,
    required R Function() orElse,
  }) {
    switch (loadStatus) {
      case _LoadStatusEnums.init:
        return onInit == null ? orElse() : onInit();
      case _LoadStatusEnums.loading:
        return onLoading == null ? orElse() : onLoading();
      case _LoadStatusEnums.loadingMore:
      case _LoadStatusEnums.done:
        return onDone == null
            ? orElse()
            : onDone(loadStatus == _LoadStatusEnums.loadingMore);
      case _LoadStatusEnums.error:
        return onError == null ? orElse() : onError();
      default:
        return orElse();
    }
  }
}

// extension LoadStatusExtension on LoadStatus{
//   bool get isDone =>
// }
