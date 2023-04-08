import 'package:flutter/material.dart';
import 'package:finance/utils.dart';
import '../constants/colors.dart';


class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10,
      unselectedLabelStyle: SafeGoogleFont(
        'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: GlobalColors.whiteAcc.withOpacity(0.8),
      ),
      selectedLabelStyle: SafeGoogleFont(
        'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: GlobalColors.whiteAcc.withOpacity(0.8),
      ),
      unselectedItemColor: GlobalColors.whiteAcc.withOpacity(0.7),
      selectedItemColor: GlobalColors.whiteAcc.withOpacity(0.7),
      type: BottomNavigationBarType.fixed,
      backgroundColor: GlobalColors.primaryColor,
      selectedIconTheme:
          IconThemeData(color: GlobalColors.whiteAcc.withOpacity(0.7)),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.send),
          icon: Icon(Icons.send_outlined),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.notifications),
          icon: Icon(Icons.notifications_outlined),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.newspaper),
          icon: Icon(Icons.newspaper_outlined),
          label: 'News',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.apps),
          icon: Icon(Icons.apps_outlined),
          label: 'More',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) => onTap(index),
    );
  }
}
