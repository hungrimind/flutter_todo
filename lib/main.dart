import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/mvvm/reactive_view_model.dart';
import 'package:todo/todo.dart';

// app wide dependencies, consider using GetIt,
// but doesn't matter much as we use constructor injection
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
    homePageViewModel.dispose();
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
    // we use [ChangeNotifierProvider.value] because we handle
    // the creation, init and disposing of the viewmodel
    // in theory we can skip this part but can be useful
    // if have a child widget and need the viewmodel
    return ChangeNotifierProvider.value(
      value: homePageViewModel,
      builder: (context, child) {
        // consumer around the entire thing because in this case we don't care
        // about optimizing rebuilds. Otherwise feel free to refactor and move consumer to a lower level widget
        //
        // If we are not using provider we can use ValueListneableBuilder
        return Consumer<TodoPageViewModel>(
          builder: (context, model, child) {
            final todos = model.state.todos;

            return Scaffold(
              appBar: AppBar(
                title: Text("Todo ${model.serviceDate}"),
                actions: [
                  if (model.state.hasNonCompletedTodos)
                    TextButton(
                      onPressed: () {
                        model.toggleCompletedTodos();
                      },
                      child: model.state.showCompletedTodos
                          ? const Text("Hide Done")
                          : const Text("Show Done"),
                    )
                ],
              ),
              body: Center(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    if (todo.completed && !model.state.showCompletedTodos) {
                      return const SizedBox();
                    }
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: todo.description != null
                          ? Text(todo.description!)
                          : null,
                      trailing: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) => model.toggleDone(todo),
                      ),
                      onLongPress: () => model.remove(todo),
                    );
                  },
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: model.updateServiceDate,
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
          },
        );
      },
    );
  }
}

/// the state class to facilitate immutability
@immutable
class TodoPageState {
  const TodoPageState({
    required this.todos,
    this.showCompletedTodos = false,
  });

  final List<Todo> todos;
  final bool showCompletedTodos;

  bool get hasNonCompletedTodos =>
      todos.where((element) => element.completed).isNotEmpty;

  TodoPageState copyWith({
    List<Todo>? todos,
    bool? showCompletedTodos,
  }) {
    return TodoPageState(
      todos: todos ?? this.todos,
      showCompletedTodos: showCompletedTodos ?? this.showCompletedTodos,
    );
  }
}

/// the viewmodel which is responsible for business logic of the page
/// this should be fully unit testable and dependencies should be constructor injected
class TodoPageViewModel extends ReactiveViewModel {
  TodoPageViewModel({required DateService dateService})
      : _dateService = dateService;

  final DateService _dateService;

  TodoPageState state = const TodoPageState(todos: []);
  DateTime get serviceDate => _dateService.date;

  /// showcase how you can initialize a viewmodel with async data
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(todos: [Todo(title: 'Created after 1 second')]);
    notifyListeners();
  }

  Future<void> add(Todo todo) async {
    state = state.copyWith(todos: [...state.todos, todo]);
    notifyListeners();
  }

  Future<void> remove(Todo todo) async {
    state = state.copyWith(
      todos: state.todos.where((element) => element != todo).toList(),
    );
    notifyListeners();
  }

  Future<void> toggleDone(Todo todo) async {
    state = state.copyWith(
      todos: state.todos.map((oldTodo) {
        // TADAS here you compare the entire object
        // but do not override == and hashcode
        // this can result in wrong objects being compared
        if (oldTodo == todo) {
          return oldTodo.copyWith(completed: !oldTodo.completed);
        }
        return oldTodo;
      }).toList(),
    );
    notifyListeners();
  }

  void toggleCompletedTodos() {
    state = state.copyWith(showCompletedTodos: !state.showCompletedTodos);
    notifyListeners();
  }

  void updateServiceDate() {
    _dateService.updateDate();
  }

  // will notifyListeners whenever a service wants pages to update
  @override
  List<Listenable> get services => [_dateService];
}

class DateService extends ChangeNotifier {
  DateTime date = DateTime.now();

  void updateDate() {
    date = DateTime.now();
    notifyListeners();
  }
}
