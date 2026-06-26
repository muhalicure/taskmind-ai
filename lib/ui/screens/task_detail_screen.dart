import 'package:flutter/material.dart';
import 'package:taskmind_ai/data/models/task.dart';
import 'package:taskmind_ai/ui/screens/add_edit_task_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task currentTask;
  bool hasChanges = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task;
  }

  Future<void> editTask() async {
    if (isNavigating) return;

    setState(() {
      isNavigating = true;
    });

    final updatedTask = await Navigator.of(context).push<Task>(
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: currentTask),
      ),
    );

    if (!mounted) return;

    if (updatedTask != null) {
      setState(() {
        currentTask = updatedTask;
        hasChanges = true;
        isNavigating = false;
      });
    } else {
      setState(() {
        isNavigating = false;
      });
    }
  }

  void deleteTask() {
    if (isNavigating) return;
    Navigator.of(context).pop('delete');
  }

  void goBack() {
    if (isNavigating) return;

    if (hasChanges) {
      Navigator.of(context).pop(currentTask);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.black : const Color(0xFFFAFAFA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDark ? Colors.white70 : const Color(0xFF666666);
    final borderColor = isDark ? Colors.white24 : const Color(0xFFEAEAEA);
    final buttonColor = isDark ? Colors.white : Colors.black;
    final buttonTextColor = isDark ? Colors.black : Colors.white;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          goBack();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          foregroundColor: textColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: goBack,
          ),
          title: Text(
            'Görev Detayı',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                currentTask.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                currentTask.description,
                style: TextStyle(
                  fontSize: 16,
                  color: secondaryTextColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              _InfoCard(
                title: 'Öncelik',
                value: currentTask.priority,
                cardColor: cardColor,
                titleColor: secondaryTextColor,
                valueColor: textColor,
                borderColor: borderColor,
              ),
              _InfoCard(
                title: 'Durum',
                value: currentTask.isCompleted ? 'Tamamlandı' : 'Tamamlanmadı',
                cardColor: cardColor,
                titleColor: secondaryTextColor,
                valueColor: textColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isNavigating ? null : editTask,
                  child: const Text(
                    'Düzenle',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isNavigating ? null : deleteTask,
                  child: const Text(
                    'Görevi Sil',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isNavigating ? null : goBack,
                  child: const Text(
                    'Geri Dön',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color cardColor;
  final Color titleColor;
  final Color valueColor;
  final Color borderColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.cardColor,
    required this.titleColor,
    required this.valueColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}