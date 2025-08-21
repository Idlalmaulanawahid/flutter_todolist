import 'package:flutter/material.dart';

import 'task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<Task> onToggle;
  final ValueChanged<Task> onEdit;
  final ValueChanged<String> onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.done,
        onChanged: (v) => onToggle(task.copyWith(done: v ?? false)),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.done ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(task),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(task.id),
          ),
        ],
      ),
    );
  }
}
