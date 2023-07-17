import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_task.dart';
import 'package:todo_app/widgets/task_item.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails(
      {super.key,
      required this.tasks,
      required this.name,
      required this.message});
  final String name;
  final String message;
  final List<TodoTask> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
          centerTitle: true,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        body: Column(children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0)),
              ),
              child: tasks.isNotEmpty
                  ? ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          task: tasks[index],
                          showDate: true,
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white),
                      ),
                    )),
            ),
          ),
        ]));
  }
}
