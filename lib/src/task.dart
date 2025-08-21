class Task {
  final String id;
  final String title;
  final bool done;

  Task({required this.id, required this.title, this.done = false});

  Task copyWith({String? id, String? title, bool? done}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] as String? ?? '',
      done: map['done'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {'title': title, 'done': done};
}
