import 'package:breedy/app/home/view/home_page.dart';
import 'package:breedy/app/settings/settings.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  final _pages = const [HomePage(), SettingsPage()];
  final _bottomNavItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/house.svg'),
      activeIcon: SvgPicture.asset('assets/icons/house_active.svg'),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset('assets/icons/wrench.svg'),
      activeIcon: SvgPicture.asset('assets/icons/wrench_active.svg'),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        useMaterial3: true,
        bottomNavigationBarTheme:
            Theme.of(context).bottomNavigationBarTheme.copyWith(
                  selectedItemColor: const Color(0xff0055D3),
                  unselectedItemColor: Colors.black,
                ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavItems,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _pages[_selectedIndex],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
