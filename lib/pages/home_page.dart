// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:task_list_sqflite/controllers/task_manager.dart';
import 'package:task_list_sqflite/data/database_helper.dart';
import 'package:task_list_sqflite/models/task.dart';
import 'package:task_list_sqflite/utils/constants.dart';
import 'package:task_list_sqflite/utils/display_dialog_helper.dart';
import 'package:task_list_sqflite/utils/modal_bottom_sheet_tarefas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  Future<void> updateList() async {
    try {
      TaskManager taskManager = TaskManager(DatabaseHelper());
      tasks = await taskManager.getTasks();
      setState(() {});
    } catch (error) {
      print("Error updating list: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQFlite Tarefas"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
              title: Text(
                tasks[index].title,
                style: TextStyle(
                  fontSize: 20,
                  decoration:
                      tasks[index].isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                tasks[index].description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  decoration:
                      tasks[index].isDone ? TextDecoration.lineThrough : null,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: listIcons[tasks[index].priority].color,
              ),
            ),
            onTap: () {
              ModalBottomSheetTarefas modalBottomSheetTarefas =
                  ModalBottomSheetTarefas();
              modalBottomSheetTarefas
                  .modalBottomSheetTarefasLF(context, tasks, index)
                  .then((value) => updateList());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          DisplayDialogHelper dialogHelper = DisplayDialogHelper();
          await dialogHelper.displayInputTarefaLF(context, false, tasks);
          await updateList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
