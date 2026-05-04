import 'package:control/control.dart';

import '../data/settings_repository.dart';
import '../model/app_settings.dart';

final class SettingsController extends StateController<AppSettings> with SequentialControllerHandler {
  SettingsController({required this.settingsRepository, required AppSettings initialSettings})
    : super(initialState: initialSettings);

  final ISettingsRepository settingsRepository;

  void setSettings(AppSettings settings) => handle(() async {
    if (!identical(settings, state)) {
      await settingsRepository.setSettings(settings);
      setState(settings);
    }
  });
}
