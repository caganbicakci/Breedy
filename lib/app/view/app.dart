import 'package:breedy/app/bloc/app_bloc.dart';
import 'package:breedy/app/constants/asset_constants.dart';
import 'package:breedy/app/constants/theme_constants.dart';
import 'package:breedy/app/home/bloc/home_bloc.dart';
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
  @override
  void initState() {
    _appBloc.add(BreedsLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      useMaterial3: true,
      bottomNavigationBarTheme:
          Theme.of(context).bottomNavigationBarTheme.copyWith(
                selectedItemColor: kPrimaryColor,
                unselectedItemColor: Colors.black,
              ),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _appBloc),
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: MaterialApp(
        theme: themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is BreedsLoading) {
              return Scaffold(
                body: Center(
                  child: Image.asset(kLoadingIconPath),
                ),
              );
            } else if (state is BreedsLoaded) {
              return Scaffold(
                appBar: buildAppBar(context.l10n),
                bottomNavigationBar: BottomNavigationBar(
                  items: kBottomNavItems(context),
                  onTap: (int index) {
                    if (index == 1) {
                      showSettingsDialog(context);
                    }
                  },
                ),
                body: const HomePage(),
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

  Future<dynamic> showSettingsDialog(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: kBorderRadiusTopCorners,
      ),
      showDragHandle: true,
      enableDrag: true,
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => const SettingsPage(),
    );
  }

  AppBar buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(
        l10n.appName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
    );
  }

  List<BottomNavigationBarItem> kBottomNavItems(BuildContext context) {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: SvgPicture.asset(kHomeIconPath),
        activeIcon: SvgPicture.asset(kHomeActiveIconPath),
        label: context.l10n.home,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(kSettingsIconPath),
        activeIcon: SvgPicture.asset(kSettingsActiveIconPath),
        label: context.l10n.settings,
      ),
    ];
  }
}
