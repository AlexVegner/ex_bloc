import 'package:ex_bloc/ex_bloc.dart';

main() async {
  final store = ExStore.instance;
  final bloc = TestBloc();
  print('afterInitial: ${bloc.state.afterInitial}');
  store.dispatch(TestEvent()); // or TestEvent().dispatch();
  await Future.delayed(Duration(seconds: 1));
  print('afterInitial: ${bloc.state.afterInitial}');
  store.getState<TestState>();
}

class TestState {
  final bool afterInitial;

  const TestState({this.afterInitial});
  factory TestState.initial() {
    return const TestState(afterInitial: false);
  }
}

class TestEvent extends ExEvent<TestState, TestBloc> {
  @override
  Stream<TestState> call(
      ExStore store, TestBloc bloc) async* {
    yield TestState(afterInitial: true);
  }
}

class TestBloc extends ExBloc<TestEvent, TestState> {

  @override
  TestState get initialState => TestState.initial();
}
