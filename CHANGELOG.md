## 1.2.0 [BREAKING CHANGE]

- For better use with null-safety, [T] data is now required. Users can set it to nullable
- With the change above, the following constructors are removed:
  - `FetchingState.loading()`
  - `FetchingState.done([T? data])`
  - `FetchingState.error([Object? error])`

## 1.1.1

- Fixed typo and methods

## 1.1.0 [BREAKING CHANGE]

- No longer require [E] Error type. By default error type to [Object], which later can be cast to your own sake.
- Added `loadingMore` state where user could you when fetching more item into current data. Useful when use with ListView, ect...
- `onDone` is now `(T? data, bool isLoadingMore)` which provide current [data] and a boolean value indicate if the [status] is [loadingMore] add the same time. This help user can still display current list and the loading indicator if fetching more data is happening.

## 1.0.1

- Add optional init parameters for `init` method

## 1.0.0

- Remove named parameters
- Fix typos

## 0.0.8

- `whenOrElse` and `when` return Widgets
- `mapOrElse` and `map` return whatever type you want.

## 0.0.7

- change to make return type more flexible.
- return Widget is not the case anymore.

## 0.0.6

- changing [`isDone`, `isInit`, `isLoading`, `isError`] to getters

## 0.0.5

- adding bool shortcut methods [`isDone`, `isInit`, `isLoading`, `isError`]

## 0.0.4

## 0.0.3

- update documents

## 0.0.2

- update license

## 0.0.1

- First publish
