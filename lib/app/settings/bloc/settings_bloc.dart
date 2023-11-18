import 'package:bloc/bloc.dart';
import 'package:breedy/app/settings/model/settings_model.dart';
import 'package:breedy/l10n/l10n.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.l10n) : super(SettingsInitial()) {
    final settingsList = [
      SettingsModel(
        title: l10n.help,
        iconLink: 'assets/settings/help.svg',
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.rate,
        iconLink: 'assets/settings/rate.svg',
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.share,
        iconLink: 'assets/settings/share.svg',
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.terms,
        iconLink: 'assets/settings/terms.svg',
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.privacy,
        iconLink: 'assets/settings/privacy.svg',
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.version,
        iconLink: 'assets/settings/version.svg',
        isInfo: true,
      ),
    ];
    on<SettingsEvent>((event, emit) {
      emit(SettingsReady(settingsList));
    });
  }
  AppLocalizations l10n;
}
