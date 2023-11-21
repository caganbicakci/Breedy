import 'package:bloc/bloc.dart';
import 'package:breedy/app/constants/asset_constants.dart';
import 'package:breedy/app/settings/model/settings_model.dart';
import 'package:breedy/l10n/l10n.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.l10n) : super(SettingsInitial()) {
    final settingsList = [
      SettingsModel(
        title: l10n.help,
        iconLink: kHelpLogoPath,
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.rate,
        iconLink: kRateLogoPath,
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.share,
        iconLink: kShareLogoPath,
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.terms,
        iconLink: kTermsLogoPath,
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.privacy,
        iconLink: kPrivacyLogoPath,
        isInfo: false,
      ),
      SettingsModel(
        title: l10n.version,
        iconLink: kVersionPath,
        isInfo: true,
      ),
    ];
    on<SettingsEvent>((event, emit) {
      emit(SettingsReady(settingsList));
    });
  }
  AppLocalizations l10n;
}
