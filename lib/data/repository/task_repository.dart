import 'package:taskmind_ai/data/dao/task_dao.dart';
import 'package:taskmind_ai/data/models/task.dart';

class TaskRepository {
  final TaskDao _taskDao = TaskDao();

  Future<int> addTask(Task task) async {
    return await _taskDao.insertTask(task);
  }

  Future<List<Task>> getTasks() async {
    return await _taskDao.getTasks();
  }

  Future<int> updateTask(Task task) async {
    return await _taskDao.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _taskDao.deleteTask(id);
  }
}