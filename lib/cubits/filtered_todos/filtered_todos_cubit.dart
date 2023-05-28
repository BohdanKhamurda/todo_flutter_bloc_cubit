import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../cubits.dart';

part 'filtered_todos_state.dart';

class FilteredTodosCubit extends Cubit<FilteredTodosState> {
  late final StreamSubscription todoFilterSubscription;
  late final StreamSubscription todoSearchSubscription;
  late final StreamSubscription todoListSubscription;

  final List<Todo> initialTodos;

  final TodoFilterCubit todoFilterCubit;
  final TodoSearchCubit todoSearchCubit;
  final TodoListCubit todoListCubit;

  FilteredTodosCubit({
    required this.initialTodos,
    required this.todoFilterCubit,
    required this.todoSearchCubit,
    required this.todoListCubit,
  }) : super(FilteredTodosState(filteredTodos: initialTodos)) {
    todoFilterSubscription = todoFilterCubit.stream.listen((todoFilterState) {
      setFilterTodos();
    });
    todoSearchSubscription = todoSearchCubit.stream.listen((todoSearchState) {
      setFilterTodos();
    });
    todoListSubscription = todoListCubit.stream.listen((todoListState) {
      setFilterTodos();
    });
  }

  void setFilterTodos() {
    List<Todo> _filteredTodos;

    switch (todoFilterCubit.state.filter) {
      case Filter.active:
        _filteredTodos =
            todoListCubit.state.todos.where((todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos =
            todoListCubit.state.todos.where((todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todoListCubit.state.todos;
        break;
    }

    if (todoSearchCubit.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((todo) => todo.desc
              .toLowerCase()
              .contains(todoSearchCubit.state.searchTerm))
          .toList();
    }

    emit(state.copyWith(filteredTodos: _filteredTodos));
  }

  @override
  Future<void> close() {
    todoFilterSubscription.cancel();
    todoListSubscription.cancel();
    todoSearchSubscription.cancel();
    return super.close();
  }
}
