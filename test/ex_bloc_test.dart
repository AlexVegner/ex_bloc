
import 'package:ex_bloc/ex_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockExStore extends Mock implements ExStore {}
class MockExBloc extends Mock implements ExBloc {}
class MyExEvent extends Mock implements ExEvent {}

class ExBlocImpl extends ExBloc<MyExEvent, dynamic> {
  @override
  get initialState => null;
} 

void main() {
  test('wait for event', () async {
    final eventIn = MyExEvent();
    final eventOutFuture = ExStore.instance.wait<MyExEvent>();
    expect(eventOutFuture, completion(equals(eventIn)));
    ExStore.instance.dispatch(eventIn);
  });

  test('test ex bloc interaction', () async {
    final eventIn = MyExEvent();
    final bloc = ExBlocImpl();
    final eventOutFuture = ExStore.instance.wait<MyExEvent>();
    expect(eventOutFuture, completion(equals(eventIn)));
    ExStore.instance.dispatch(eventIn);
    await untilCalled(eventIn.call(any, any));
    verify(eventIn.call(ExStore.instance, bloc)).called(1);
    verifyNoMoreInteractions(eventIn);
  });
  
}
