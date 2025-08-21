import 'package:cloud_firestore/cloud_firestore.dart';

import 'task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;

  FirestoreService({this.collectionPath = 'tasks'});

  Stream<List<Task>> tasksStream() {
    final query = _db.collection(collectionPath).orderBy('title');
    return query.snapshots().map(
      (snap) => snap.docs.map((d) => Task.fromMap(d.id, d.data())).toList(),
    );
  }

  Future<void> addTask(Task task) async {
    await _db.collection(collectionPath).add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _db.collection(collectionPath).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _db.collection(collectionPath).doc(id).delete();
  }
}
