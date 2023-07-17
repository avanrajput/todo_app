import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_task.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.task, this.showDate});

  final TodoTask task;

  final bool? showDate;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    Widget optionalDate = const SizedBox.shrink();
    if (widget.showDate != null) {
      optionalDate = widget.showDate!
          ? Positioned(
              top: 10,
              left: 20,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Text(
                    widget.task.date,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    }

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Card(
            margin: const EdgeInsets.all(25),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.6),
                          shape: BoxShape.circle),
                      child: Icon(
                        categoryIcons[widget.task.category],
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.task.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: Text(
                (widget.task.startTime).toString(),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
        optionalDate
      ],
    );
  }
}
