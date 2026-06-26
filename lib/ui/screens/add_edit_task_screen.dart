import 'package:flutter/material.dart';
import 'package:taskmind_ai/data/models/task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedPriority = 'Orta';

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveTask() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Görev başlığı boş olamaz.'),
        ),
      );
      return;
    }

    final savedTask = Task(
      id: widget.task?.id,
      title: title,
      description: description.isEmpty ? 'Açıklama eklenmedi.' : description,
      priority: selectedPriority,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    Navigator.pop(context, savedTask);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.black : const Color(0xFFFAFAFA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white54 : Colors.black45;
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    final buttonColor = isDark ? Colors.white : Colors.black;
    final buttonTextColor = isDark ? Colors.black : Colors.white;

    InputDecoration inputDecoration(String hintText) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: textColor, width: 1.4),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: textColor,
        title: Text(
          isEditing ? 'Görev Düzenle' : 'Görev Ekle',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Başlık', style: TextStyle(color: textColor)),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                style: TextStyle(color: textColor),
                cursorColor: textColor,
                decoration: inputDecoration('Örn: Flutter projesi çalış'),
              ),
              const SizedBox(height: 20),
              Text('Açıklama', style: TextStyle(color: textColor)),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                style: TextStyle(color: textColor),
                cursorColor: textColor,
                decoration: inputDecoration('Görev hakkında kısa not...'),
              ),
              const SizedBox(height: 20),
              Text('Öncelik', style: TextStyle(color: textColor)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedPriority,
                dropdownColor: cardColor,
                style: TextStyle(color: textColor),
                iconEnabledColor: textColor,
                decoration: inputDecoration('Öncelik seç'),
                items: const [
                  DropdownMenuItem(value: 'Düşük', child: Text('Düşük')),
                  DropdownMenuItem(value: 'Orta', child: Text('Orta')),
                  DropdownMenuItem(value: 'Yüksek', child: Text('Yüksek')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPriority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
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
                  onPressed: saveTask,
                  child: Text(
                    isEditing ? 'Güncelle' : 'Kaydet',
                    style: const TextStyle(fontWeight: FontWeight.w600),
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