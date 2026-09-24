import 'package:shared_preferences/shared_preferences.dart';

class SessionSnapshot {
  final bool loggedIn;
  final String? email;
  final DateTime? loggedAt;
  final double? latitude;
  final double? longitude;

  const SessionSnapshot({
    required this.loggedIn,
    this.email,
    this.loggedAt,
    this.latitude,
    this.longitude,
  });

  bool get hasLocation => latitude != null && longitude != null;
}

class SessionStorage {
  static const _loginKey = 'loginRealizado';
  static const _emailKey = 'emailUsuario';
  static const _dateKey = 'dataLogin';
  static const _latitudeKey = 'latitude';
  static const _longitudeKey = 'longitude';

  const SessionStorage();

  Future<SessionSnapshot> read() async {
    final prefs = await SharedPreferences.getInstance();
    final dateValue = prefs.getString(_dateKey);
    return SessionSnapshot(
      loggedIn: prefs.getBool(_loginKey) ?? false,
      email: prefs.getString(_emailKey),
      loggedAt: dateValue == null ? null : DateTime.tryParse(dateValue),
      latitude: prefs.getDouble(_latitudeKey),
      longitude: prefs.getDouble(_longitudeKey),
    );
  }

  Future<void> saveLogin({
    required String email,
    double? latitude,
    double? longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_dateKey, DateTime.now().toIso8601String());

    if (latitude != null && longitude != null) {
      await prefs.setDouble(_latitudeKey, latitude);
      await prefs.setDouble(_longitudeKey, longitude);
    } else {
      await prefs.remove(_latitudeKey);
      await prefs.remove(_longitudeKey);
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
    await prefs.remove(_emailKey);
    await prefs.remove(_dateKey);
    await prefs.remove(_latitudeKey);
    await prefs.remove(_longitudeKey);
  }
}

String formatCoordinate(double? value) {
  if (value == null) return '--';
  return value.toStringAsFixed(5);
}

String formatSessionDate(DateTime? value) {
  if (value == null) return 'acesso recente';
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} · $hour:$minute';
}
