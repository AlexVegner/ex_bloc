import 'dart:async';

import 'package:bloc/bloc.dart';

import '../ex_bloc.dart';
import './ex_event.dart';
import './ex_store.dart';

abstract class ExBloc<Event extends ExEvent, State> extends Bloc<Event, State> {
  StreamSubscription<Event> _subscription;
  ExBloc() : super() {
    ExStore.instance.add<State>(this);
    _subscription =
        ExStore.instance.on<Event>().listen((Event event) => add(event));
    if (initialEvents.isNotEmpty) {
      initialEvents.forEach((e) {
        ExStore.instance.dispatch(e);
      });
    }
  }

  bool get sync => false;

  List<Event> get initialEvents => [];

  @override
  Future<void> close() {
    ExStore.instance.remove<State>(this);
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<State> mapEventToState(ExEvent event) async* {
    // if (sync || event is ExStateEvent) {
    yield* event.call(ExStore.instance, this);
    // } else {
    //   runAsync(event);
    // }
  }

  Future<void> runAsync(ExEvent event) async {
    await for (State state in event.call(ExStore.instance, this)) {

    }
  }
}

class EmptyServiceModel {
  const EmptyServiceModel();
}
