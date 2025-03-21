import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/screens/add_edit_task/add_edit_task.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final Function() callBack;
  final bool offlineMode;

  const TaskCard({
    Key? key,
    required this.task,
    required this.callBack,
    this.offlineMode = false,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with TickerProviderStateMixin {
  bool isExpanded = false;

  String formatDate(DateTime date) {
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditTask(
              isEdit: true,
              task: widget.task,
              offLineMode: widget.offlineMode,
            ),
          ),
        );
        widget.callBack();
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.task.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.task.category,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    Text(
                      widget.task.description,
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    if (widget.task.description.length > 50)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded ? "Read Less" : "Read More",
                            style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Task Due Date & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Due: ${formatDate(widget.task.dueDate)}",
                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                  Text(
                    widget.task.status == "Completed"
                        ? "Completed ✅"
                        : widget.task.status == "Not Started"
                        ? "Not Started"
                        : "In Progress ❌",
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.task.status == "Completed"
                          ? Colors.green
                          : widget.task.status == "In Progress"
                          ? Colors.red
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
