import 'package:flutter/material.dart';
import 'package:task_list_sqflite/controllers/task_manager.dart';
import 'package:task_list_sqflite/data/database_helper.dart';
import 'package:task_list_sqflite/models/task.dart';
import 'package:task_list_sqflite/utils/display_dialog_helper.dart';

class ModalBottomSheetTarefas {
  TaskManager taskManager = TaskManager(DatabaseHelper());
  Future<void> modalBottomSheetTarefasLF(
    BuildContext context,
    List<Task> listTask,
    int index,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildActionButton(
                  context,
                  listTask[index].isDone ? "Voltar estágio" : "Finalizar",
                  () => _handleFinishTask(context, listTask, index),
                ),
                _buildActionButton(
                  context,
                  "Editar",
                  () => _handleEditTask(context, listTask, index),
                ),
                _buildActionButton(
                  context,
                  "Excluir",
                  () => _handleDeleteTask(context, listTask, index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildActionButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  void _handleFinishTask(BuildContext context, List<Task> listTask, int index) {
    taskManager
        .finishTask(listTask[index])
        .then((value) => Navigator.pop(context));
  }

  static void _handleEditTask(
      BuildContext context, List<Task> listTask, int index) {
    DisplayDialogHelper dialogHelper = DisplayDialogHelper();
    dialogHelper
        .displayInputTarefaLF(context, true, listTask, index: index)
        .then((value) {
      Navigator.pop(context);
    });
  }

  void _handleDeleteTask(BuildContext context, List<Task> listTask, int index) {
    taskManager
        .deleteTask(listTask[index].id!)
        .then((value) => Navigator.pop(context));
  }
}
