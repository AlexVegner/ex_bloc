import 'dart:async';

import './utils.dart';

import './ex_bloc.dart';
import 'ex_event.dart';

class ExStore {
  StreamController _streamController;

  /// Controller for the event bus stream.
  StreamController get streamController => _streamController;

  static ExStore _singleton = ExStore();
  ExStore({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  ExStore.customController(StreamController controller)
      : _streamController = controller;

  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  Future<T> wait<T>() {
    return on<T>().first;
  }

  static ExStore get instance => _singleton;

  static void initWith(ExStore exStore) {
    _singleton = exStore;
  }

  static bool enabled = true;

  Map<Type, ExBloc> stateMap = {};

  final List<ExEventHandler> handlers = [];

  void dispatchAll(List<ExEvent> events) {
    if (enabled) {
      events.forEach((e) => dispatch(e));
      streamController.addStream(Stream.fromIterable(events));
    }
  }

  void dispatch(ExEvent event) {
    if (enabled) {
      streamController.add(event);
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

  void destroy() {
    _streamController.close();
  }
}

abstract class ExEventHandler {
  void handleEvent(ExEvent event);
}
