import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/all_workouts/presentation/pages/all_workouts.dart';
import 'package:nextrep/features/home/presentation/pages/home_screen.dart';
import 'package:nextrep/features/profile/presentation/pages/profile_screen.dart';
import 'package:nextrep/features/progress/presentation/progress_screen.dart';

class BottomNavigatorController extends StatefulWidget {
  const BottomNavigatorController({super.key});

  @override
  State<BottomNavigatorController> createState() =>
      _BottomNavigatorControllerState();
}

class _BottomNavigatorControllerState extends State<BottomNavigatorController> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    KeepAlivePage(child: HomeScreen()),
    KeepAlivePage(child: AllWorkouts()),
    KeepAlivePage(child: ProgressScreen()),
    KeepAlivePage(child: ProfileScreen()),
  ];

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,

          onTap: _onItemTapped,

          selectedItemColor: AppPalette.primary,
          unselectedItemColor: AppPalette.notSelected,
          backgroundColor: AppPalette.transparent,

          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 22),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.dumbbell),
              label: "Workout",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.barsProgress),
              label: "Progress",
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

/// Keeps state alive for each tab
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  const KeepAlivePage({super.key, required this.child});

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // required with KeepAlive
    return widget.child;
  }
}
