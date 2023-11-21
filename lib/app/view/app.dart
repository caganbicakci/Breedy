import 'package:breedy/app/bloc/app_bloc.dart';
import 'package:breedy/app/home/view/home_page.dart';
import 'package:breedy/app/settings/settings.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppBloc _appBloc = AppBloc();
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
  void initState() {
    _appBloc.add(BreedsLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _appBloc,
      child: MaterialApp(
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
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is BreedsLoading) {
              return Scaffold(
                body: Center(
                  child: Image.asset('assets/icons/loading.png'),
                ),
              );
            } else if (state is BreedsLoaded) {
              return Scaffold(
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
              );
            } else {
              return Container();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
