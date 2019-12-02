import './utils.dart';

import './ex_bloc.dart';
import 'ex_event.dart';

class ExStore {
  static ExStore _singleton = ExStore();
  ExStore();
  static ExStore get instance => _singleton;

  static void initWith(ExStore exStore) {
    _singleton = exStore;
  }

  static bool enabled = true;

  Map<Type, ExBloc> stateMap = {};

  final List<ExEventHandler> handlers = [];

  void dispatch(ExEvent event) {
    if (enabled) {
      stateMap.forEach((key, bloc) {
        bloc.handleEvent(event);
      });
    }
  }

  State getState<State>() => stateMap[typeOf<State>()]?.state as State;

  void add<State>(ExBloc bloc) {
    stateMap[typeOf<State>()] = bloc;
  }

  void remove<State>(ExEventHandler eventHandler) {
    stateMap.remove(typeOf<State>());
  }
}

abstract class ExEventHandler {
  handleEvent(ExEvent event);
}