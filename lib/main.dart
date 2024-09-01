import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/todo.dart';

// app wide dependencies, consider using GetIt to override
// dependencies in tests if wanted
late final DateService dateService;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  dateService = DateService();

  runApp(
    MaterialApp(
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
        ),
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final homePageViewModel = TodoPageViewModel(dateService: dateService);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homePageViewModel.init();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                homePageViewModel.add(
                  Todo(
                    title: _titleController.text,
                    description: _descriptionController.text,
                  ),
                );

                _titleController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: homePageViewModel.serviceDate,
          builder: (context, date, child) {
            return Text("Todo $date");
          },
        ),
        actions: [
          ValueListenableBuilder2(
            first: homePageViewModel.todos,
            second: homePageViewModel.showCompletedTodos,
            builder: (context, todos, showCompletedTodos, child) {
              if (homePageViewModel.hasNonCompletedTodos) {
                return TextButton(
                  onPressed: () {
                    homePageViewModel.toggleCompletedTodos();
                  },
                  child: showCompletedTodos
                      ? const Text("Hide Done")
                      : const Text("Show Done"),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: TodoList(
        toggleDone: homePageViewModel.toggleDone,
        removeTodo: homePageViewModel.remove,
        todosNotifier: homePageViewModel.todos,
        showCompletedTodos: homePageViewModel.showCompletedTodos,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: homePageViewModel.updateServiceDate,
            child: const Icon(Icons.date_range),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: _addTodo,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todosNotifier,
    required this.showCompletedTodos,
    required this.toggleDone,
    required this.removeTodo,
  });

  final ValueNotifier<List<Todo>> todosNotifier;
  final ValueNotifier<bool> showCompletedTodos;
  final void Function(Todo todo) toggleDone;
  final void Function(Todo todo) removeTodo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: todosNotifier,
      builder: (context, todos, child) {
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoItem(
              showCompletedTodos: showCompletedTodos,
              todo: todo,
              toggleDone: toggleDone,
              removeTodo: removeTodo,
            );
          },
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.showCompletedTodos,
    required this.todo,
    required this.toggleDone,
    required this.removeTodo,
  });

  final ValueNotifier<bool> showCompletedTodos;
  final Todo todo;
  final void Function(Todo todo) toggleDone;
  final void Function(Todo todo) removeTodo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showCompletedTodos,
      builder: (context, showCompletedTodos, child) {
        if (todo.completed && !showCompletedTodos) {
          return const SizedBox();
        }

        return ListTile(
          title: Text(todo.title),
          subtitle: todo.description != null ? Text(todo.description!) : null,
          trailing: Checkbox(
            value: todo.completed,
            onChanged: (bool? value) => toggleDone(todo),
          ),
          onLongPress: () => removeTodo(todo),
        );
      },
    );
  }
}

/// the viewmodel which is responsible for business logic of the page
/// this should be fully unit testable and dependencies should be constructor injected
class TodoPageViewModel {
  TodoPageViewModel({required DateService dateService})
      : _dateService = dateService;

  final DateService _dateService;
  ValueNotifier<DateTime> get serviceDate => _dateService.dateNotifier;

  final ValueNotifier<List<Todo>> todos = ValueNotifier([]);
  final ValueNotifier<bool> showCompletedTodos = ValueNotifier(false);

  bool get hasNonCompletedTodos =>
      todos.value.where((element) => element.completed).isNotEmpty;

  /// showcase how you can initialize a viewmodel with async data
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    todos.value = [Todo(title: 'Created after 1 second')];
  }

  Future<void> add(Todo todo) async {
    todos.value = [...todos.value, todo];
  }

  Future<void> remove(Todo todo) async {
    todos.value = todos.value.where((element) => element != todo).toList();
  }

  Future<void> toggleDone(Todo todo) async {
    todos.value = todos.value.map((oldTodo) {
      // TADAS here you compare the entire object
      // but do not override == and hashcode
      // this can result in wrong objects being compared
      if (oldTodo == todo) {
        return oldTodo.copyWith(completed: !oldTodo.completed);
      }
      return oldTodo;
    }).toList();
  }

  void toggleCompletedTodos() {
    showCompletedTodos.value = !showCompletedTodos.value;
  }

  void updateServiceDate() {
    _dateService.updateDate();
  }
}

class DateService {
  ValueNotifier<DateTime> dateNotifier = ValueNotifier(DateTime.now());

  void updateDate() {
    dateNotifier.value = DateTime.now();
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2({
    required this.first,
    required this.second,
    super.key,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}

class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  const ValueListenableBuilder3({
    required this.first,
    required this.second,
    required this.third,
    super.key,
    required this.builder,
    this.child,
  });

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, C c, Widget? child)
      builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, c, __) {
                return builder(context, a, b, c, child);
              },
            );
          },
        );
      },
    );
  }
}
