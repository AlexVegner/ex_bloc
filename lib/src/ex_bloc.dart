import 'package:bloc/bloc.dart';

import './ex_event.dart';
import './ex_store.dart';

abstract class ExBloc<Event extends ExEvent, State, SModel>
    extends Bloc<Event, State> implements ExEventHandler {
  final SModel _sm;
  ExBloc(SModel sm)
      : _sm = sm,
        super() {
    ExStore.instance.add<State>(this);
  }

  @override
  Future<void> close() {
    ExStore.instance.remove<State>(this);
    return super.close();
  }

  @override
  handleEvent(ExEvent event) {
    if (event is Event) {
      add(event);
    }
  }

  @override
  Stream<State> mapEventToState(ExEvent event) async* {
    yield* event.call(ExStore.instance, state, _sm);
  }
}

class EmptyServiceModel {
  const EmptyServiceModel();
}
