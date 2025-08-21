import 'package:flutter/material.dart';

import 'firestore_service.dart';
import 'task.dart';
import 'task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: StreamBuilder<List<Task>>(
        stream: service.tasksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final t = tasks[index];
              return TaskTile(
                task: t,
                onToggle: (updated) async => await service.updateTask(updated),
                onEdit: (task) async {
                  final newTitle = await showDialog<String>(
                    context: context,
                    builder: (ctx) {
                      final controller = TextEditingController(
                        text: task.title,
                      );
                      return AlertDialog(
                        title: const Text('Edit task'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.of(ctx).pop(controller.text),
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                  if (newTitle != null && newTitle.trim().isNotEmpty) {
                    await service.updateTask(task.copyWith(title: newTitle));
                  }
                },
                onDelete: (id) async {
                  await service.deleteTask(id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await showDialog<String>(
            context: context,
            builder: (ctx) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('New task'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(controller.text),
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );

          if (title != null && title.trim().isNotEmpty) {
            await service.addTask(Task(id: '', title: title.trim()));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
