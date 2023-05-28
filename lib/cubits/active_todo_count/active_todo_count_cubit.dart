import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  final int initalActiveTodoCount;

  ActiveTodoCountCubit({
    required this.initalActiveTodoCount,
  }) : super(ActiveTodoCountState(activeTodoCount: initalActiveTodoCount));

  void calculateActiveTodoCount(int activeTodoCount) {
    emit(state.copyWith(activeTodoCount: activeTodoCount));
  }
}
