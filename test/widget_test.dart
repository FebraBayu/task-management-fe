import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_tracker/models/task.dart';

void main() {
  test('parses task response', () {
    final task = Task.fromJson({
      'id': 1,
      'title': 'Beli Susu',
      'description': 'Beli yang full cream',
      'status': 'Pending',
      'created_at': '2026-06-16T15:00:30.701636+07:00',
      'updated_at': '2026-06-16T15:00:30.701636+07:00',
    });

    expect(task.id, 1);
    expect(task.title, 'Beli Susu');
    expect(task.description, 'Beli yang full cream');
    expect(task.status, 'Pending');
    expect(task.isDone, isFalse);
  });
}
