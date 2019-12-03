import 'package:ex_bloc/ex_bloc.dart';

main() async {
  final store = ExStore.instance;
  final bloc = TestBloc(EmptyServiceModel());
  print('afterInitial: ${bloc.state.afterInitial}');
  store.dispatch(TestEvent());
  await Future.delayed(Duration(seconds: 1));
  print('afterInitial: ${bloc.state.afterInitial}');
}

class TestState {
  final bool afterInitial;

  const TestState({this.afterInitial});
  factory TestState.initial() {
    return const TestState(afterInitial: false);
  }
}

class TestEvent extends ExEvent<TestState, EmptyServiceModel> {
  @override
  Stream<TestState> call(
      ExStore store, TestState state, EmptyServiceModel sm) async* {
    yield TestState(afterInitial: true);
  }
}

class TestBloc extends ExBloc<TestEvent, TestState, EmptyServiceModel> {
  TestBloc(EmptyServiceModel sm) : super(sm);

  @override
  TestState get initialState => TestState.initial();
}
