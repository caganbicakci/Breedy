import 'dart:io' show Platform;

import 'package:breedy/app/settings/bloc/settings_bloc.dart';
import 'package:breedy/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(context.l10n),
      child: SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  SettingsView({super.key});
  final osVersion = Platform.operatingSystemVersion;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsInitial) {
          context.read<SettingsBloc>().add(SettingsEvent());
        }
        if (state is SettingsReady) {
          return ListView.separated(
            separatorBuilder: (_, index) {
              return const Divider(
                color: Color(0xffE5E5EA),
                thickness: 2,
                height: 2,
              );
            },
            itemCount: state.settingsList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.settingsList[index].title),
                leading: SvgPicture.asset(state.settingsList[index].iconLink),
                trailing: state.settingsList[index].isInfo == true
                    ? Text(osVersion)
                    : SvgPicture.asset('assets/settings/arrow.svg'),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
