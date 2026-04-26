import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'notif_logic.dart';
import 'notif.dart';
import 'local_notif.dart';
import '../fik/camera_main.dart';
import '../hikmah/profile_screen.dart';
import '../hans/location_main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // disini ubah data
  int battery = 25;
  int used = 1200;
  int remaining = 200;
  bool isOnline = false;
  String lastLocation = "Jalan ketintang No.159";

  bool alreadyNotified = false;

  @override
  void initState() {
    super.initState();
    checkNotification();
  }

  void checkNotification() {
    if (alreadyNotified) return;

    final notifications = generateNotifications(
      battery: battery,
      remaining: remaining,
      isOnline: isOnline,
      lastLocation: lastLocation,
    );

    for (var n in notifications) {
      NotificationHelper.showNotification(
        title: n.title,
        body: n.message,
      );
    }

    alreadyNotified = true;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = generateNotifications(
      battery: battery,
      remaining: remaining,
      isOnline: isOnline,
      lastLocation: lastLocation,
    );

    final List<Widget> pages = [
      DashboardScreen(
        battery: battery,
        used: used,
        remaining: remaining,
        isOnline: isOnline,
      ),
      TrackingScreen(),
      CameraMain(),
      NotificationScreen(notifications: notifications),
      ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: Container(
        height: 85,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,

          selectedItemColor: const Color(0xFF223148),
          unselectedItemColor: Colors.grey,

          selectedFontSize: 12,
          unselectedFontSize: 11,
          iconSize: 26,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "Lokasi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: "Camera",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Alert",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}