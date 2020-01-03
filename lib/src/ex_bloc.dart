import 'dart:async';

import 'package:bloc/bloc.dart';

import './ex_event.dart';
import './ex_store.dart';

abstract class ExBloc<Event extends ExEvent, State> extends Bloc<Event, State>
    implements ExEventHandler {
  StreamSubscription<Event> _subscription;
  ExBloc() : super() {
    ExStore.instance.add<State>(this);
    _subscription =
        ExStore.instance.on<Event>().listen((Event event) => this.add(event));
    if (initialEvents.isNotEmpty) {
      initialEvents.forEach((e) {
        ExStore.instance.dispatch(e);
      });
    }
  }

  List<Event> get initialEvents => [];

  @override
  Future<void> close() {
    ExStore.instance.remove<State>(this);
    _subscription.cancel();
    return super.close();
  }

  @override
  void handleEvent(ExEvent event) {
    if (event is Event) {
      add(event);
    }
  }

  @override
  Stream<State> mapEventToState(ExEvent event) async* {
    yield* event.call(ExStore.instance, this);
  }
}

class EmptyServiceModel {
  const EmptyServiceModel();
}
