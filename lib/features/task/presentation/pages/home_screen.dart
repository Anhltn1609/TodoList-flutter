import 'package:flutter/material.dart';
import 'package:todolistsqlite/features/task/data/data_sources/db_handler.dart';
import 'package:todolistsqlite/features/task/data/models/TodoModel.dart';
import 'package:todolistsqlite/features/task/presentation/pages/add_update_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          "todolist",
          style: TextStyle(
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
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No tasks found"),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int todoId = snapshot.data![index].id!.toInt();
                    String todoTitle = snapshot.data![index].title.toString();
                    String todoDesc = snapshot.data![index].des.toString();
                    String dateTime = snapshot.data![index].dateTime.toString();
                    return Dismissible(
                      key: ValueKey<int>(todoId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.redAccent,
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          dbHelper!.delete(todoId);
                          dataList = dbHelper!.getDataList();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade300,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ]),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  todoTitle,
                                  style: const TextStyle(fontSize: 19),
                                ),
                              ),
                              subtitle: Text(
                                todoDesc,
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 0.8,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateTime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddUpdateTask(
                                                  todoId: todoId,
                                                  todoDes: todoDesc,
                                                  todoDT: dateTime,
                                                  todoTitle: todoTitle,
                                                  update: true,
                                                )),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit_note,
                                      color: Colors.green,
                                      size: 28,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              }
            },
            future: dataList,
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUpdateTask(),
              ));
        },
      ),
    );
  }
}
