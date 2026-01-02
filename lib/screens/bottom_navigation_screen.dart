
import 'package:flutter/material.dart';
import 'package:gotrek/screens/auth/login_screen.dart';
import 'package:gotrek/screens/bottom_screens/admin_bottom_screens.dart';
import 'package:gotrek/screens/bottom_screens/group_bottom_screen.dart';
import 'package:gotrek/screens/bottom_screens/home_bottom_screen.dart';
import 'package:gotrek/screens/bottom_screens/profile_bottom_screen.dart';
import 'package:gotrek/screens/bottom_screens/setting_bottom_screen.dart';

class BottonNavigationScreen extends StatefulWidget {
  const BottonNavigationScreen({super.key});

  @override
  State<BottonNavigationScreen> createState() => _BottonNavigationScreenState();
}

class _BottonNavigationScreenState extends State<BottonNavigationScreen> {
  int _selectedIndex=0;
  
  List<Widget> lsBottomScreen=[
    const HomeBottomScreen(),
    const GroupBottomScreen(),
    const ProfileBottomScreen(),
    const AdminBottomScreens(),
    const SettingBottomScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: lsBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 56, 117, 214),
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex=index;
          });
        }
      ),
    );
  }
}