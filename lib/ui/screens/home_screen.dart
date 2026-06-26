import 'package:flutter/material.dart';
import 'package:taskmind_ai/business/task_service.dart';
import 'package:taskmind_ai/business/theme_service.dart';
import 'package:taskmind_ai/data/models/task.dart';
import 'package:taskmind_ai/ui/screens/add_edit_task_screen.dart';
import 'package:taskmind_ai/ui/screens/assistant_screen.dart';
import 'package:taskmind_ai/ui/screens/settings_screen.dart';
import 'package:taskmind_ai/ui/screens/statistics_screen.dart';
import 'package:taskmind_ai/ui/screens/task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();

  List<Task> tasks = [];
  bool isLoading = true;

  final List<String> motivations = const [
    'Küçük adımlar büyük sonuçlar doğurur.',
    'Bugün bir görevi bitirmek, yarının yükünü hafifletir.',
    'Mükemmel olmak zorunda değilsin, devam etmen yeter.',
    'Plan yapmak iyidir ama tamamlamak efsanedir.',
    'Bir görev daha, bir adım daha.',
    'Odaklan, başla, bitir.',
  ];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final loadedTasks = await taskService.getTasks();

    setState(() {
      tasks = loadedTasks;
      isLoading = false;
    });
  }

  Future<void> openAddTaskScreen() async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditTaskScreen(),
      ),
    );

    if (result != null) {
      await taskService.addTask(result);
      await loadTasks();
    }
  }

  Future<void> openTaskDetailScreen(int index) async {
    final result = await Navigator.push<Object?>(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: tasks[index]),
      ),
    );

    if (result == 'delete') {
      final taskId = tasks[index].id;

      if (taskId != null) {
        await taskService.deleteTask(taskId);
        await loadTasks();
      }
    } else if (result is Task) {
      await taskService.updateTask(result);
      await loadTasks();
    }
  }

  Future<void> toggleTaskCompleted(int index) async {
    final task = tasks[index];

    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
    );

    await taskService.updateTask(updatedTask);
    await loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((task) => task.isCompleted).length;

    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.instance.isDarkMode,
      builder: (context, isDark, child) {
        final backgroundColor =
            isDark ? const Color(0xFF111111) : const Color(0xFFFAFAFA);
        final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
        final completedCardColor =
            isDark ? const Color(0xFF2A2A2D) : const Color(0xFFF1F1F1);
        final primaryTextColor = isDark ? Colors.white : Colors.black;
        final secondaryTextColor =
            isDark ? const Color(0xFFB0B0B0) : const Color(0xFF666666);
        final borderColor =
            isDark ? const Color(0xFF333333) : const Color(0xFFEAEAEA);
        final iconColor = isDark ? Colors.white : Colors.black;
        final fabBackground = isDark ? Colors.white : Colors.black;
        final fabForeground = isDark ? Colors.black : Colors.white;

        final motivationText = motivations[tasks.length % motivations.length];

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: false,
            title: Text(
              'TaskMind AI',
              style: TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'İstatistikler',
                icon: Icon(Icons.bar_chart_rounded, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsScreen(tasks: tasks),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Akıllı Asistan',
                icon: Icon(Icons.auto_awesome, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssistantScreen(tasks: tasks),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Ayarlar',
                icon: Icon(Icons.settings_outlined, color: iconColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: primaryTextColor),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bugünkü Görevler',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedCount / ${tasks.length} görev tamamlandı',
                        style: TextStyle(
                          fontSize: 16,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Expanded(
                        child: tasks.isEmpty
                            ? Center(
                                child: Text(
                                  'Henüz görev yok.\nYeni bir görev ekleyerek başlayabilirsin.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: tasks.length + 1,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  if (index == tasks.length) {
                                    return _MotivationCard(
                                      text: motivationText,
                                      cardColor: cardColor,
                                      borderColor: borderColor,
                                      primaryTextColor: primaryTextColor,
                                      secondaryTextColor: secondaryTextColor,
                                    );
                                  }

                                  final task = tasks[index];

                                  return InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () {
                                      openTaskDetailScreen(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        color: task.isCompleted
                                            ? completedCardColor
                                            : cardColor,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: borderColor),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              toggleTaskCompleted(index);
                                            },
                                            child: Icon(
                                              task.isCompleted
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              color: iconColor,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: task.isCompleted
                                                        ? secondaryTextColor
                                                        : primaryTextColor,
                                                    decoration: task.isCompleted
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                    decorationColor:
                                                        secondaryTextColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Öncelik: ${task.priority}',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: secondaryTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: secondaryTextColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: fabBackground,
            foregroundColor: fabForeground,
            onPressed: openAddTaskScreen,
            icon: const Icon(Icons.add),
            label: const Text('Görev Ekle'),
          ),
        );
      },
    );
  }
}

class _MotivationCard extends StatelessWidget {
  final String text;
  final Color cardColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const _MotivationCard({
    required this.text,
    required this.cardColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 96),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: primaryTextColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugünün Motivasyonu',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}