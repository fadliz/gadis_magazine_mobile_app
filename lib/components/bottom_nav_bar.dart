import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            break;
          case 1:
            Navigator.pushNamed(context, '/articles');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            color: selectedIndex == 0 ? const Color(0xFFFD507E) : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            selectedIndex == 1 ? 'assets/icons/article-pink.svg':'assets/icons/article.svg',
          ),
          label: 'Article',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/profile.svg',
            color: selectedIndex == 2 ? const Color(0xFFFD507E) : Colors.grey,
          ),
          label: 'Account',
        ),
      ],
      selectedItemColor: const Color(0xFFFD507E),
    );
  }
}
