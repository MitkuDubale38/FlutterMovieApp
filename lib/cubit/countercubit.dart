import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counterstate.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(counterValue: 0, wasIncremented: false));

  void Increment() => emit(CounterState(counterValue: state.counterValue + 1, wasIncremented: true));
  void Decrement() => emit(CounterState(counterValue: state.counterValue - 1, wasIncremented: false));
  void resetCounter() => emit(CounterState(counterValue: 0, wasIncremented: false));
}
