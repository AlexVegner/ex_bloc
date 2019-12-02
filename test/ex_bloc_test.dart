
import 'package:ex_bloc/ex_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockExStore extends Mock implements ExStore {}
class MockExBloc extends Mock implements ExBloc {}

void main() {
  test('adds one to input values', () {
    // TODO
    final store = MockExStore();
    ExStore.initWith(store);
    // ExStore.instance.dispatch(event)

  });
}
