import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/database/todo_db.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/widgets/create_todo_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  Future<List<Todo>>? futureTodos;
  final todoDB = TodoDB();

  @override
  void initState() {
    // todoDB.deleteAllData();
    super.initState();
    fetchTodos();
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }  else {
            final todos = snapshot.data!;
            return todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos....',
                      style: TextStyle(
                        fontFamily: 'title_font',
                        fontSize: 30,
                      ),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      print('item ${todo.title} ${todo.createdAt} ${todo.updatedAt} ${todo.id}');
                      final subtitle = DateFormat('dd/mm/yyyy').format(
                          DateTime.parse(todo.updatedAt ?? todo.createdAt));
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: 72,
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(subtitle),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await todoDB.delete(todo.id);
                              fetchTodos();
                            },
                          ),
                          onTap: () {
                            print('item : ${todo.id}, index : $index');
                            showDialog(
                              context: context,
                              builder: (context) => CreateTodoWidget(
                                todo : todo,
                                onSubmit: (title) async {
                                  await todoDB.update(
                                      id: todo.id -1, title: title);
                                  fetchTodos();
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTodoWidget(
              onSubmit: (title) async {
                await todoDB.create(title: title);
                if (!mounted) return;
                fetchTodos();
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}
