import 'package:control/control.dart';
import 'package:flutter/widgets.dart';

import '../../../common/extension/context_extension.dart';
import '../controller/settings_controller.dart';
import '../model/app_settings.dart';

/// {@template settings_scope}
/// SettingsScope widget.
/// {@endtemplate}
class SettingsScope extends StatefulWidget {
  /// {@macro settings_scope}
  const SettingsScope({required this.child, super.key});

  /// The child widget.
  final Widget child;

  /// Get the [SettingsBloc] instance.
  static SettingsController of(BuildContext context, {bool listen = false}) =>
      context.controllerOf<SettingsController>(listen: listen);

  /// Get the [AppSettings] instance.
  static AppSettings settingsOf(BuildContext context, {bool listen = false}) =>
      context.controllerOf<SettingsController>(listen: listen).state;

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

/// State for widget SettingsScope.
class _SettingsScopeState extends State<SettingsScope> {
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _settingsController = context.x.dependencies.settingsController;
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ControllerScope<SettingsController>.value(_settingsController, child: widget.child);
}
