import 'package:flutter/material.dart';
import 'package:taskmind_ai/data/models/task.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Task> tasks;

  const StatisticsScreen({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.black : const Color(0xFFFAFAFA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : const Color(0xFF666666);
    final descriptionColor = isDark ? Colors.white60 : const Color(0xFF555555);
    final borderColor = isDark ? Colors.white24 : const Color(0xFFEAEAEA);
    final progressBackgroundColor =
        isDark ? Colors.white24 : const Color(0xFFEAEAEA);
    final progressColor = isDark ? Colors.white : Colors.black;

    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = totalTasks - completedTasks;

    final successRate =
        totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();

    final progressValue = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: textColor,
        title: Text(
          'İstatistikler',
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
              'Haftalık Özet',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Görev tamamlama performansın burada görünecek.',
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 28),

            _ProgressCard(
              successRate: successRate,
              progressValue: progressValue,
              totalTasks: totalTasks,
              completedTasks: completedTasks,
              cardColor: cardColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              descriptionColor: descriptionColor,
              borderColor: borderColor,
              progressColor: progressColor,
              progressBackgroundColor: progressBackgroundColor,
            ),

            _StatCard(
              title: 'Toplam Görev',
              value: '$totalTasks',
              description: 'Şu anda listende bulunan görev sayısı.',
              cardColor: cardColor,
              titleColor: secondaryTextColor,
              valueColor: textColor,
              descriptionColor: descriptionColor,
              borderColor: borderColor,
            ),
            _StatCard(
              title: 'Tamamlanan',
              value: '$completedTasks',
              description: 'Bitirdiğin görevlerin toplamı.',
              cardColor: cardColor,
              titleColor: secondaryTextColor,
              valueColor: textColor,
              descriptionColor: descriptionColor,
              borderColor: borderColor,
            ),
            _StatCard(
              title: 'Bekleyen',
              value: '$pendingTasks',
              description: 'Henüz tamamlanmamış görevlerin.',
              cardColor: cardColor,
              titleColor: secondaryTextColor,
              valueColor: textColor,
              descriptionColor: descriptionColor,
              borderColor: borderColor,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int successRate;
  final double progressValue;
  final int totalTasks;
  final int completedTasks;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color descriptionColor;
  final Color borderColor;
  final Color progressColor;
  final Color progressBackgroundColor;

  const _ProgressCard({
    required this.successRate,
    required this.progressValue,
    required this.totalTasks,
    required this.completedTasks,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.descriptionColor,
    required this.borderColor,
    required this.progressColor,
    required this.progressBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Başarı Oranı',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '%$successRate',
            style: TextStyle(
              color: textColor,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 10,
              backgroundColor: progressBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$totalTasks görevden $completedTasks tanesi tamamlandı.',
            style: TextStyle(
              color: descriptionColor,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final Color cardColor;
  final Color titleColor;
  final Color valueColor;
  final Color descriptionColor;
  final Color borderColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.description,
    required this.cardColor,
    required this.titleColor,
    required this.valueColor,
    required this.descriptionColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: descriptionColor,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}