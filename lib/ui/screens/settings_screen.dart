import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmind_ai/business/notification_service.dart';
import 'package:taskmind_ai/business/theme_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool morningEnabled = false;
  bool noonEnabled = false;
  bool eveningEnabled = false;
  bool darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      morningEnabled = prefs.getBool('morning_notification') ?? false;
      noonEnabled = prefs.getBool('noon_notification') ?? false;
      eveningEnabled = prefs.getBool('evening_notification') ?? false;
      darkModeEnabled = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _toggleMorning(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('morning_notification', value);

    if (value) {
      await NotificationService.instance.showTestNotification();

      await NotificationService.instance.scheduleDailyNotification(
        id: 1,
        title: 'Günaydın ☀️',
        body: 'Bugünkü görevlerini kontrol etme zamanı.',
        hour: 9,
        minute: 0,
      );
    } else {
      await NotificationService.instance.cancelNotification(1);
    }

    setState(() => morningEnabled = value);
  }

  Future<void> _toggleNoon(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('noon_notification', value);

    if (value) {
      await NotificationService.instance.scheduleTestNotificationAfterSeconds(10);

      await NotificationService.instance.scheduleDailyNotification(
        id: 2,
        title: 'Öğle Kontrolü',
        body: 'Bugünkü ilerlemeni kontrol etmeye ne dersin?',
        hour: 13,
        minute: 0,
      );
    } else {
      await NotificationService.instance.cancelNotification(2);
    }

    setState(() => noonEnabled = value);
  }

  Future<void> _toggleEvening(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('evening_notification', value);

    if (value) {
      await NotificationService.instance.scheduleDailyNotification(
        id: 3,
        title: 'Gün Sonu Değerlendirmesi',
        body: 'Bugün neleri tamamladığını gözden geçirme zamanı.',
        hour: 20,
        minute: 0,
      );
    } else {
      await NotificationService.instance.cancelNotification(3);
    }

    setState(() => eveningEnabled = value);
  }

  Future<void> _toggleDarkMode(bool value) async {
    await ThemeService.instance.setDarkMode(value);
    setState(() => darkModeEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.black : const Color(0xFFFAFAFA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor =
        isDark ? Colors.white70 : const Color(0xFF666666);
    final borderColor = isDark ? Colors.white24 : const Color(0xFFEAEAEA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: primaryTextColor,
        title: Text(
          'Ayarlar',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Uygulama Ayarları',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Bildirim, görünüm ve motivasyon tercihleri.',
              style: TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
              ),
            ),

            const SizedBox(height: 28),

            _SettingsSwitchCard(
              title: 'Sabah Bildirimi',
              value: morningEnabled ? 'Açık' : 'Kapalı',
              description: 'Güne başlarken günlük görev özeti. Test için anlık bildirim gönderir.',
              isEnabled: morningEnabled,
              onChanged: _toggleMorning,
              cardColor: cardColor,
              borderColor: borderColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),

            _SettingsSwitchCard(
              title: 'Öğle Bildirimi',
              value: noonEnabled ? 'Açık' : 'Kapalı',
              description: 'Günün ortasında ilerleme kontrolü. Test için 10 saniye sonra bildirim gönderir.',
              isEnabled: noonEnabled,
              onChanged: _toggleNoon,
              cardColor: cardColor,
              borderColor: borderColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),

            _SettingsSwitchCard(
              title: 'Akşam Bildirimi',
              value: eveningEnabled ? 'Açık' : 'Kapalı',
              description: 'Gün sonu değerlendirmesi ve motivasyon.',
              isEnabled: eveningEnabled,
              onChanged: _toggleEvening,
              cardColor: cardColor,
              borderColor: borderColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),

            _SettingsSwitchCard(
              title: 'Koyu Tema',
              value: darkModeEnabled ? 'Açık' : 'Kapalı',
              description: 'Siyah-beyaz koyu arayüz modu.',
              isEnabled: darkModeEnabled,
              onChanged: _toggleDarkMode,
              cardColor: cardColor,
              borderColor: borderColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final Color cardColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const _SettingsSwitchCard({
    required this.title,
    required this.value,
    required this.description,
    required this.isEnabled,
    required this.onChanged,
    required this.cardColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  value,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: isDark ? Colors.black : Colors.white,
            activeTrackColor: isDark ? Colors.white : Colors.black,
            inactiveThumbColor: isDark ? Colors.white : Colors.black,
            inactiveTrackColor:
                isDark ? const Color(0xFF333333) : const Color(0xFFEAEAEA),
            trackOutlineColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF666666) : const Color(0xFFCCCCCC),
            ),
          ),
        ],
      ),
    );
  }
}