import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../todo_list/todo_list_cubit.dart';

part 'active_todo_count_state.dart';

class ActiveTodoCountCubit extends Cubit<ActiveTodoCountState> {
  late final StreamSubscription todoListSubscription;

  final int initalActiveTodoCount;
  final TodoListCubit todoListCubit;

  ActiveTodoCountCubit({
    required this.initalActiveTodoCount,
    required this.todoListCubit,
  }) : super(ActiveTodoCountState(activeTodoCount: initalActiveTodoCount)) {
    todoListSubscription = todoListCubit.stream.listen((todoListState) {
      print('todoListState: $todoListState');

      final int currentActiveTodoCount =
          todoListState.todos.where((todo) => !todo.completed).toList().length;
      
      emit(state.copyWith(activeTodoCount: currentActiveTodoCount));
    });
  }

  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
