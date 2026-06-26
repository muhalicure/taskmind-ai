import 'package:taskmind_ai/data/models/task.dart';
import 'package:taskmind_ai/data/repository/task_repository.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();

  Future<int> addTask(Task task) async {
    return await _repository.addTask(task);
  }

  Future<List<Task>> getTasks() async {
    return await _repository.getTasks();
  }

  Future<int> updateTask(Task task) async {
    return await _repository.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _repository.deleteTask(id);
  }
}