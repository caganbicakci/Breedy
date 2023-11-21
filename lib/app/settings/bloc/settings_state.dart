part of 'settings_bloc.dart';

class SettingsState {}

final class SettingsInitial extends SettingsState {}

class SettingsReady extends SettingsState {
  SettingsReady(this.settingsList);
  final List<SettingsModel> settingsList;
}
