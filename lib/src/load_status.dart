import 'package:fetching_state/src/enums.dart';

/// A mixin to use with classes that have to do with loading status.
/// This mixin will attach `loadStatus` attribute into that class along with it are many helper methods for easily checking and setting current `loadStatus`.
/// There are also helper methods to render widget or perform action base on current `loadStatus` (when, whenOrElse, map, mapOrElse)
mixin LoadStatusMixin {
  LoadState loadStatus = LoadState.init;
  void setLoadStatusInit() => loadStatus = LoadState.init;
  void setLoadStatusLoading() => loadStatus = LoadState.loading;
  void setLoadStatusLoadMore() => loadStatus = LoadState.loadingMore;
  void setLoadStatusDone() => loadStatus = LoadState.done;
  void setLoadStatusError() => loadStatus = LoadState.error;

  bool get isInit => loadStatus == LoadState.init;
  bool get isLoading => loadStatus == LoadState.loading;
  bool get isLoadMore => loadStatus == LoadState.loadingMore;
  bool get isDone => loadStatus == LoadState.done;
  bool get isError => loadStatus == LoadState.error;

  R when<R>({
    required R Function() onLoading,
    required R Function(bool isLoadingMore) onDone,
    required R Function() onError,
    required R Function() onInit,
  }) {
    switch (loadStatus) {
      case LoadState.init:
        return onInit();
      case LoadState.loading:
        return onLoading();
      case LoadState.loadingMore:
      case LoadState.done:
        return onDone(loadStatus == LoadState.loadingMore);
      case LoadState.error:
        return onError();
    }
  }

  R whenOrElse<R>({
    R Function()? onLoading,
    R Function(bool isLoadingMore)? onDone,
    R Function()? onError,
    R Function()? onInit,
    required R Function() orElse,
  }) {
    switch (loadStatus) {
      case LoadState.init:
        return onInit == null ? orElse() : onInit();
      case LoadState.loading:
        return onLoading == null ? orElse() : onLoading();
      case LoadState.loadingMore:
      case LoadState.done:
        return onDone == null
            ? orElse()
            : onDone(loadStatus == LoadState.loadingMore);
      case LoadState.error:
        return onError == null ? orElse() : onError();
      default:
        return orElse();
    }
  }
}

// extension LoadStatusExtension on LoadStatus{
//   bool get isDone =>
// }
