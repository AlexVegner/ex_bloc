import 'package:bloc/bloc.dart';

import './ex_event.dart';
import './ex_store.dart';

abstract class ExBloc<Event extends ExEvent, State> extends Bloc<Event, State>
    implements ExEventHandler {
  ExBloc() : super() {
    ExStore.instance.add<State>(this);
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
