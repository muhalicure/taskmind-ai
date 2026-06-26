import 'package:flutter/material.dart';
import 'package:taskmind_ai/data/models/task.dart';

class AssistantScreen extends StatelessWidget {
  final List<Task> tasks;

  const AssistantScreen({
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
    final cardTextColor = isDark ? Colors.white70 : const Color(0xFF555555);
    final borderColor = isDark ? Colors.white24 : const Color(0xFFEAEAEA);

    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = totalTasks - completedTasks;

    final highPriorityTasks = tasks
        .where((task) => task.priority == 'Yüksek' && !task.isCompleted)
        .toList();

    final successRate =
        totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();

    String dailyPlanMessage;

    if (totalTasks == 0) {
      dailyPlanMessage =
          'Bugün için henüz görev eklenmemiş. Küçük bir hedef belirleyerek başlayabilirsin.';
    } else if (highPriorityTasks.isNotEmpty) {
      dailyPlanMessage =
          'Bugün $pendingTasks bekleyen görevin var. Önce "${highPriorityTasks.first.title}" görevine odaklanmanı öneriyorum.';
    } else {
      dailyPlanMessage =
          'Bugün $pendingTasks bekleyen görevin var. Görevleri sırayla ve sakin şekilde tamamlayabilirsin.';
    }

    String progressMessage;

    if (successRate >= 80) {
      progressMessage =
          'Harika gidiyorsun. Görevlerinin büyük kısmını tamamlamışsın.';
    } else if (successRate >= 50) {
      progressMessage =
          'İyi ilerliyorsun. Kalan görevleri küçük parçalara bölerek devam edebilirsin.';
    } else if (totalTasks == 0) {
      progressMessage =
          'Henüz ölçülecek bir ilerleme yok. İlk görevini ekleyince burası anlam kazanacak.';
    } else {
      progressMessage =
          'Henüz yolun başındasın. En kolay görevden başlayıp ritim yakalayabilirsin.';
    }

    String motivationMessage;

    if (pendingTasks == 0 && totalTasks > 0) {
      motivationMessage =
          'Bugünkü tüm görevleri tamamladın. Bu küçük zaferleri hafife alma.';
    } else if (highPriorityTasks.isNotEmpty) {
      motivationMessage =
          'Önemli işi önce bitirmek günü hafifletir. Kurbağayı sabah yemek diye bir laf var; biraz çirkin ama çalışıyor.';
    } else {
      motivationMessage =
          'Küçük ama düzenli ilerleme, büyük sıçramalardan daha güvenilirdir.';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: textColor,
        title: Text(
          'Akıllı Asistan',
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
              'Bugünün Yorumu',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Görevlerine göre sade ve uygulanabilir öneriler.',
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 28),

            _AssistantCard(
              title: 'Günlük Plan',
              text: dailyPlanMessage,
              cardColor: cardColor,
              titleColor: textColor,
              textColor: cardTextColor,
              borderColor: borderColor,
            ),
            _AssistantCard(
              title: 'İlerleme Durumu',
              text:
                  '$totalTasks görevden $completedTasks tanesini tamamladın. Başarı oranın: %$successRate.',
              cardColor: cardColor,
              titleColor: textColor,
              textColor: cardTextColor,
              borderColor: borderColor,
            ),
            _AssistantCard(
              title: 'Öncelik Önerisi',
              text: progressMessage,
              cardColor: cardColor,
              titleColor: textColor,
              textColor: cardTextColor,
              borderColor: borderColor,
            ),
            _AssistantCard(
              title: 'Motivasyon',
              text: motivationMessage,
              cardColor: cardColor,
              titleColor: textColor,
              textColor: cardTextColor,
              borderColor: borderColor,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AssistantCard extends StatelessWidget {
  final String title;
  final String text;
  final Color cardColor;
  final Color titleColor;
  final Color textColor;
  final Color borderColor;

  const _AssistantCard({
    required this.title,
    required this.text,
    required this.cardColor,
    required this.titleColor,
    required this.textColor,
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
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}