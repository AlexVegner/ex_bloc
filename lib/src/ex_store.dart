import 'dart:async';

import './utils.dart';

import './ex_bloc.dart';
import 'ex_event.dart';

class ExStore {
  final StreamController _streamController;

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

  Stream<T> where<T>(bool Function(T) test) {
    return streamController.stream.where(test).cast<T>();
  }

  Future<T> wait<T>({Duration timeLimit}) {
    if (timeLimit != null) {
      return on<T>().timeout(timeLimit).first;
    } else {
      return on<T>().first;
    }
  }

  Future<T> waitWhere<T>(bool Function(T) test, {Duration timeLimit}) {
    if (timeLimit != null) {
      return where<T>(test).timeout(timeLimit).first;
    } else {
      return where<T>(test).first;
    }
  }

  static ExStore get instance => _singleton;

  static void initWith(ExStore exStore) {
    _singleton = exStore;
  }

  static bool enabled = true;

  Map<Type, ExBloc> stateMap = {};

  void dispatchAll(List<ExEvent> events) {
    if (enabled) {
      streamController.addStream(Stream.fromIterable(events));
    }
  }

  void dispatch(ExEvent event) {
    if (enabled) {
      streamController.add(event);
    }
  }

  State getState<State>() => stateMap[typeOf<State>()]?.state as State;

  void add<State>(ExBloc bloc) {
    stateMap[typeOf<State>()] = bloc;
  }

  void remove<State>(ExBloc eventHandler) {
    stateMap.remove(typeOf<State>());
  }

  void destroy() {
    _streamController.close();
  }
}
