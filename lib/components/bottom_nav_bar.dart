import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/articles');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Article',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      selectedItemColor: Colors.pink,
    );
  }
}
