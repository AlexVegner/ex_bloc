import 'ex_store.dart';

abstract class ExEvent<S, B> {
  const ExEvent();

  Stream<S> call(ExStore store, B bloc);

  void dispatch() {
    ExStore.instance.dispatch(this);
  }
}

abstract class ExStateEvent {}