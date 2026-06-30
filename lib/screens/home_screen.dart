import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'cameras_screen.dart';
import 'events_screen.dart';
import 'recordings_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final pages = const [DashboardScreen(), CamerasScreen(), EventsScreen(), RecordingsScreen(), SettingsScreen()];
  @override Widget build(BuildContext context) => Scaffold(
    body: pages[index],
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (i)=>setState(()=>index=i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
        NavigationDestination(icon: Icon(Icons.videocam_outlined), selectedIcon: Icon(Icons.videocam), label: 'Câmeras'),
        NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Eventos'),
        NavigationDestination(icon: Icon(Icons.video_library_outlined), selectedIcon: Icon(Icons.video_library), label: 'Gravações'),
        NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Mais'),
      ],
    ),
  );
}
