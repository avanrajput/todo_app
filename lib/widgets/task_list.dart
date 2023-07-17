import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_task.dart';
import 'package:todo_app/widgets/task_item.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
    required this.inputTodoList,
    required this.onRemoveTask,
    required this.onCompleteTask,
  });

  final void Function(TodoTask task) onRemoveTask;

  final List<TodoTask> inputTodoList;

  final void Function(List<TodoTask> task) onCompleteTask;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TodoTask> completedTasks = [];
  Future<bool?> _confirmDeleteTask(BuildContext context, TodoTask task) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _completeTask(TodoTask task) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                task.description,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Start Time: ${task.startTime}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'End Time: ${task.endTime}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  completedTasks.contains(task)
                      ? _removeTask(task)
                      : _addCompletedTask(task);

                  widget.onCompleteTask(completedTasks);
                  Navigator.pop(context);
                },
                child: completedTasks.contains(task)
                    ? const Text('Mark as Incomplete')
                    : const Text('Mark as Complete'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addCompletedTask(TodoTask task) {
    setState(() {
      completedTasks.add(task);
    });
  }

  void _removeTask(TodoTask task) {
    setState(() {
      completedTasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.inputTodoList.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: ValueKey(widget.inputTodoList[index]),
              confirmDismiss: (direction) async {
                return _confirmDeleteTask(context, widget.inputTodoList[index]);
              },
              onDismissed: (direction) {
                widget.onRemoveTask(widget.inputTodoList[index]);
              },
              child: InkWell(
                onTap: () => _completeTask(widget.inputTodoList[index]),
                child: TaskItem(task: widget.inputTodoList[index]),
              ));
        },
      ),
    );
  }
}
