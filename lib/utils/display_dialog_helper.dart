// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:task_list_sqflite/controllers/task_manager.dart';
import 'package:task_list_sqflite/data/database_helper.dart';
import 'package:task_list_sqflite/models/task.dart';
import 'package:task_list_sqflite/utils/constants.dart';

class DisplayDialogHelper {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> displayInputTarefaLF(
      BuildContext context, bool isUpdate, List<Task> listTask,
      {int? index}) {
    Icon dropdownValue = listIcons.first;
    return showDialog(
      context: context,
      builder: (context) {
        if (isUpdate) {
          titleController.text = listTask[index!].title;
          descriptionController.text = listTask[index].description;
          dropdownValue = listIcons[listTask[index].priority];
        }
        return AlertDialog(
          title: isUpdate
              ? const Text('Alterar Tarefa')
              : const Text('Nova Tarefa'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(hintText: "Titulo da tarefa"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration:
                        const InputDecoration(hintText: "Descricao da tarefa"),
                  ),
                  Row(
                    children: [
                      const Text("Prioridade: "),
                      DropdownButton<Icon>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        focusColor: Colors.transparent,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (Icon? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            listIcons.map<DropdownMenuItem<Icon>>((Icon value) {
                          return DropdownMenuItem<Icon>(
                            value: value,
                            child: value,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            _buildMaterialButton(
                "CANCELAR", Colors.red, () => Navigator.pop(context)),
            _buildMaterialButton(
              "OK",
              Colors.green,
              () => _handleOkButtonPressed(
                  isUpdate, listTask, index, context, dropdownValue),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMaterialButton(
      String label, Color color, VoidCallback onPressed) {
    return MaterialButton(
      color: color,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(label),
    );
  }

  void _handleOkButtonPressed(
    bool isUpdate,
    List<Task> listTask,
    int? index,
    BuildContext context,
    Icon dropdownValue,
  ) {
    TaskManager taskManager = TaskManager(DatabaseHelper());
    if (isUpdate && index != null) {
      Task task = listTask[index];
      task.title = titleController.text;
      task.description = descriptionController.text;
      task.priority = listIcons.indexOf(dropdownValue);

      taskManager
          .editTask(task)
          .then((value) => Navigator.pop(context))
          .catchError((error) => print('Error updating task: $error'));
    } else {
      Task task = Task(
        title: titleController.text,
        description: descriptionController.text,
        isDone: false,
        priority: listIcons.indexOf(dropdownValue),
      );
      taskManager
          .addTask(task)
          .then((value) => Navigator.pop(context))
          .catchError((error) => print('Error adding task: $error'));
    }
  }
}
