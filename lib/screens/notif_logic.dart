class AppNotification {
  final String title;
  final String message;
  final String type;

  AppNotification({
    required this.title,
    required this.message,
    required this.type,
  });
}

List<AppNotification> generateNotifications({
  required int battery,
  required int remaining,
  required bool isOnline,
  required String lastLocation,
}) {
  List<AppNotification> list = [];

  if (battery < 30) {
    list.add(AppNotification(
      title: "Baterai Rendah",
      message: "Sisa baterai $battery%",
      type: "warning",
    ));
  }

  if (remaining < 100) {
    list.add(AppNotification(
      title: "Kuota Hampir Habis",
      message: "Sisa $remaining MB",
      type: "warning",
    ));
  }

  if (!isOnline) {
    list.add(AppNotification(
      title: "Perangkat Offline",
      message: "Terakhir di $lastLocation",
      type: "critical",
    ));
  }

  return list;
}