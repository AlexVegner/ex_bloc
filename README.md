# ex_bloc

ExBloc provide simple way to organize bloc middleware and dispatch events.

## Usage

# Import

```dart
import 'package:ex_bloc/ex_bloc.dart';
```

# Get ExStore
```dart
final store = ExStore.instance;
```

# Simple state

```dart
class TestState {
  final bool afterInitial;

  const TestState({this.afterInitial});
  factory TestState.initial() {
    return const TestState(afterInitial: false);
  }
}
```

# Simple bloc

`ExBloc` does not contain business logic.

```dart
class TestBloc extends ExBloc<TestEvent, TestState> {

  @override
  TestState get initialState => TestState.initial();
}
```

# Event

`ExEvent` provide business logic and payload

`ExStore` provide ability to dispatch other events or get other states. 

```dart
class TestEvent extends ExEvent<TestState, TestBloc> {
  @override
  Stream<TestState> call(
      ExStore store, TestBloc bloc) async* {
    yield TestState(afterInitial: true);
  }
}
```

# Dispatch events

```dart
store.dispatch(TestEvent());
```
or
```dart
TestEvent().dispatch();
```

# Get state from ExStore

```dart
final store = ExStore.instance;
final testState = store.getState<TestState>();
```

# Reselect usage

[Reselect](https://pub.dev/packages/reselect) can be used if needed

```dart
final testStateSelector = (ExStore store) => store.getState<TestState>();

final afterInitialSelector = createSelector1(
    testStateSelector,
    (TestState testState) => testState.afterInitial,
);
```