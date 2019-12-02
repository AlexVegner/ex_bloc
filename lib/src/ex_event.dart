import 'ex_store.dart';

abstract class ExEvent<T, SModel> {
  const ExEvent();

  Stream<T> call(ExStore store, T state, SModel sm);

  void dispatch() {
    ExStore.instance.dispatch(this);
  }
}
