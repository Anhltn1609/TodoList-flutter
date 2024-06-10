import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolistsqlite/features/task/data/data_sources/db_handler.dart';
import 'package:todolistsqlite/features/task/data/models/TodoModel.dart';
import 'package:todolistsqlite/features/task/presentation/pages/home_screen.dart';

class AddUpdateTask extends StatefulWidget {
  final int? todoId;
  final String? todoTitle;
  final String? todoDes;
  final String? todoDT;
  final bool? update;

  const AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDes,
    this.todoDT,
    this.update,
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;
  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDes);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Update task";
    } else {
      appTitle = "Add task";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_outlined,
              size: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _fromKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Note Title",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter some text";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      controller: descController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Note description",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter some text";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              if (_fromKey.currentState!.validate()) {
                                if (widget.update == true) {
                                  dbHelper!.update(TodoModel(
                                      id: widget.todoId,
                                      title: titleController.text,
                                      des: descController.text,
                                      dateTime: DateFormat('yMd')
                                          .add_jm()
                                          .format(DateTime.now())
                                          .toString()));
                                } else {
                                  dbHelper!.insert(TodoModel(
                                      title: titleController.text,
                                      des: descController.text,
                                      dateTime: DateFormat('yMd')
                                          .add_jm()
                                          .format(DateTime.now())
                                          .toString()));
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomeScreen()));
                                titleController.clear();
                                descController.clear();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 55,
                              width: 120,
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                titleController.clear();
                                descController.clear();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 55,
                              width: 120,
                              child: const Text(
                                "Clear",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
