import 'package:test_task_tracker/models/task.dart';
import 'package:test_task_tracker/utils/services/rest_api_services.dart';

class TaskRepository {
  TaskRepository({DioService? dioService})
    : _dioService = dioService ?? DioService();

  final DioService _dioService;

  Future<List<Task>> getTasks({required int page, required int limit}) async {
    final response = await _dioService.get(
      'tasks',
      queryParameters: {'page': page, 'limit': limit},
    );
    final responseData = response.data;
    final data = responseData is List<dynamic>
        ? responseData
        : responseData is Map<String, dynamic>
        ? responseData['data'] as List<dynamic>? ?? []
        : <dynamic>[];
    return data
        .map((item) => Task.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<Task> getTaskById(int id) async {
    final response = await _dioService.get('tasks/$id');
    return Task.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<Task> createTask({
    required String title,
    required String description,
  }) async {
    final response = await _dioService.post(
      'tasks',
      data: {'title': title, 'description': description},
    );
    return Task.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<Task> updateTask({
    required int id,
    required String title,
    required String description,
  }) async {
    final response = await _dioService.put(
      'tasks/$id',
      data: {'title': title, 'description': description},
    );
    return Task.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<Task> updateTaskStatus({
    required int id,
    required String status,
  }) async {
    final response = await _dioService.patch(
      'tasks/$id',
      data: {'status': status},
    );
    return Task.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> deleteTask(int id) async {
    await _dioService.delete('tasks/$id');
  }
}
