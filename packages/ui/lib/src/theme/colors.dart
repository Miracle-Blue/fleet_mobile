import 'package:flutter/material.dart';

/// {@template app_colors}
/// Emphasis class
/// Theme colors for the application:
/// https://www.figma.com/design/p0hEruNSQcCxBp54vmMAq1/Sun-ELD-%7C-Theme-Colors?node-id=0-1&p=f&t=MW2A08M5LHbUihPb-0
/// {@endtemplate}
@immutable
final class ThemeColors extends ThemeExtension<ThemeColors> {
  /// {@macro app_colors}
  const ThemeColors({
    required this.error,
    required this.onError,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.success,
    required this.onSuccess,
    required this.surface,
    required this.onSurface,
    required this.tealBlue,
    required this.tertiary,
    required this.tertiaryBold,
    required this.onTertiary,

    // Base colors
    required this.black,
    required this.gray,
    required this.transparent,
    required this.white,
    required this.green,

    // Widget-specific colors
    required this.buttonBorder,
    required this.buttonFill,
    required this.divider,
    required this.primaryButtonFill,
    required this.primaryButtonBorder,

    // text color
    required this.text,

    // duty status circles colors
    required this.breakC,
    required this.driveC,
    required this.shiftC,
    required this.cycleC,
    required this.themeToggle,
  });

  factory ThemeColors.of(BuildContext context) {
    try {
      final theme = Theme.of(context);
      return theme.extension<ThemeColors>() ??
          switch (theme.brightness) {
            Brightness.light => ThemeColors.light,
            Brightness.dark => ThemeColors.dark,
          };
    } on Object {
      return ThemeColors.light;
    }
  }

  /// Error color light[0xFFff2f22] dark[0xFFff2f22]
  final Color error;

  /// Error color on error light[0xFFF8F9FA] dark[0xFFF8F9FA]
  final Color onError;

  /// Primary color light[0xFF1C60E8] dark[0xFF1C60E8]
  final Color primary;

  /// Primary color on primary light[0xFFF2F7F7] dark[0xFF1A1F22]
  final Color onPrimary;

  /// Secondary color light[0xFFF8F9FA] dark[0xFFE1EBF0]
  final Color secondary;

  /// Secondary color on secondary light[0xFF1A1F22] dark[0xFFF8F9FA]
  final Color onSecondary;

  /// Success color light[0xFF0CD678] dark[0xFF0CD678]
  final Color success;

  /// Success color on success light[0xFFF8F9FA] dark[0xFFF8F9FA]
  final Color onSuccess;

  /// Surface color light[0xFFF8F9FA] dark[0xFF1A1F22]
  final Color surface;

  /// Surface color on surface light[0xFF202732] dark[0xFF202732]
  final Color onSurface;

  /// Teal blue color light[0xFF026492] dark[0xFF026492]
  final Color tealBlue;

  /// Tertiary color light[0xFF0CD678] dark[0xFF0CD678]
  final Color tertiary;

  /// Tertiary bold color light[0xFF09AC60] dark[0xFF09AC60]
  final Color tertiaryBold;

  /// Tertiary bold color on tertiary light[0xFFF8F9FA] dark[0xFFF8F9FA]
  final Color onTertiary;

  /// Black color light[0xFF000000] dark[0xFF000000]
  final Color black;

  /// Gray color light[0xFFA0A9BA] dark[0xFFA0A9BA]
  final Color gray;

  /// Transparent color light[0x00000000] dark[0x00000000]
  final Color transparent;

  /// White color light[0xFFF8F9FA] dark[0xFFF8F9FA]
  final Color white;

  /// Green color light[0xFF099250] dark[0xFF099250]
  final Color green;

  /// Button border color light[0xFFE1EBF0] dark[0xFF41484C]
  final Color buttonBorder;

  /// Button fill color light[0xFFA1ADB5] dark[0xFFA1ADB5]
  final Color buttonFill;

  /// Divider color light[0xFFE1EBF0] dark[0xFF41484C]
  final Color divider;

  /// Primary button fill color light[0xFF18ACEC] dark[0xFF18ACEC]
  final Color primaryButtonFill;

  /// Primary button border color light[0xFF1594CA] dark[0xFF1594CA]
  final Color primaryButtonBorder;

  /// Text color light[0xFF202732] dark[0xFFF8F9FA]
  final Color text;

  /// duty status circles colors
  ///
  /// light[0xFFF79009] dark[0xFFF79009]
  final Color breakC;

  /// light[0xFF12B76A] dark[0xFF12B76A]
  final Color driveC;

  /// light[0xFF1594CA] dark[0xFF1594CA]
  final Color shiftC;

  /// light[0xFFff2f22] dark[0xFFff2f22]
  final Color cycleC;

  /// theme toggle color light[0xFF202732] dark[0xFFF8F9FA]
  final Color themeToggle;

  /// The default light theme colors.
  static const light = ThemeColors(
    error: Color(0xFFFF2F22),
    onError: Color(0xFFF8F9FA),
    primary: Color(0xFF1C60E8),
    onPrimary: Color(0xFFF2F7F7),
    secondary: Color(0xFFF8F9FA),
    onSecondary: Color(0xFF1A1F22),
    success: Color(0xFF0CD678),
    onSuccess: Color(0xFFF8F9FA),
    surface: Color(0xFFF8F9FA),
    onSurface: Color(0xFF202732),
    tealBlue: Color(0xFF026492),
    tertiary: Color(0xFF0CD678),
    tertiaryBold: Color.fromARGB(255, 9, 172, 96),
    onTertiary: Color(0xFFF8F9FA),

    // Base colors
    black: Color(0xFF000000),
    gray: Color(0xFFA0A9BA),
    transparent: Color(0x00000000),
    white: Color(0xFFF8F9FA),
    green: Color(0xFF099250),

    // Widget-specific colors
    buttonBorder: Color(0xFFE1EBF0),
    buttonFill: Color(0xFFA1ADB5),
    divider: Color(0xFFE1EBF0),
    primaryButtonFill: Color(0xFFF8F9FA),
    primaryButtonBorder: Color(0xFF1594CA),

    // text color
    text: Color(0xFF202732),

    // duty status circles colors
    breakC: Color(0xFFF79009),
    driveC: Color(0xFF12B76A),
    shiftC: Color(0xFF1594CA),
    cycleC: Color(0xFFFF2F22),

    // theme toggle color
    themeToggle: Color(0xFF202732),
  );

  /// The default dark theme colors.
  static const dark = ThemeColors(
    error: Color(0xFFFF2F22),
    onError: Color(0xFFF8F9FA),
    primary: Color(0xFF1C60E8),
    onPrimary: Color(0xFF1A1F22),
    secondary: Color.fromARGB(255, 44, 51, 56),
    onSecondary: Color(0xFFF8F9FA),
    success: Color(0xFF0CD678),
    onSuccess: Color(0xFFF8F9FA),
    surface: Color(0xFF1A1F22),
    onSurface: Color(0xFF202732),
    tealBlue: Color(0xFF026492),
    tertiary: Color(0xFF0CD678),
    tertiaryBold: Color.fromARGB(255, 9, 172, 96),
    onTertiary: Color(0xFFF8F9FA),

    // Base colors
    black: Color(0xFF000000),
    gray: Color(0xFFA0A9BA),
    transparent: Color(0x00000000),
    white: Color(0xFFF8F9FA),
    green: Color(0xFF099250),

    // Widget-specific colors
    buttonBorder: Color(0xFF41484C),
    buttonFill: Color(0xFFA1ADB5),
    divider: Color(0xFF41484C),
    primaryButtonFill: Color(0xFF344054),
    primaryButtonBorder: Color(0xFF1594CA),

    // text color
    text: Color(0xFFF8F9FA),

    // duty status circles colors
    breakC: Color(0xFFF79009),
    driveC: Color(0xFF12B76A),
    shiftC: Color(0xFF1594CA),
    cycleC: Color(0xFFFF2F22),

    // theme toggle color
    themeToggle: Color(0xFFF8F9FA),
  );

  @override
  ThemeColors copyWith({
    Color? error,
    Color? onError,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? success,
    Color? onSuccess,
    Color? surface,
    Color? onSurface,
    Color? tealBlue,
    Color? tertiary,
    Color? tertiaryBold,
    Color? onTertiary,

    // Base colors
    Color? black,
    Color? gray,
    Color? transparent,
    Color? white,
    Color? green,

    // Widget-specific colors
    Color? buttonBorder,
    Color? buttonFill,
    Color? divider,
    Color? primaryButtonFill,
    Color? primaryButtonBorder,

    // text color
    Color? text,

    // duty status circles colors
    Color? breakC,
    Color? driveC,
    Color? shiftC,
    Color? cycleC,
    Color? themeToggle,
  }) => ThemeColors(
    error: error ?? this.error,
    onError: onError ?? this.onError,
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    secondary: secondary ?? this.secondary,
    onSecondary: onSecondary ?? this.onSecondary,
    success: success ?? this.success,
    onSuccess: onSuccess ?? this.onSuccess,
    surface: surface ?? this.surface,
    onSurface: onSurface ?? this.onSurface,
    tealBlue: tealBlue ?? this.tealBlue,
    tertiary: tertiary ?? this.tertiary,
    tertiaryBold: tertiaryBold ?? this.tertiaryBold,
    onTertiary: onTertiary ?? this.onTertiary,

    // Base colors
    black: black ?? this.black,
    gray: gray ?? this.gray,
    transparent: transparent ?? this.transparent,
    white: white ?? this.white,
    green: green ?? this.green,

    // Widget-specific colors
    buttonBorder: buttonBorder ?? this.buttonBorder,
    buttonFill: buttonFill ?? this.buttonFill,
    divider: divider ?? this.divider,
    primaryButtonFill: primaryButtonFill ?? this.primaryButtonFill,
    primaryButtonBorder: primaryButtonBorder ?? this.primaryButtonBorder,

    // text color
    text: text ?? this.text,

    // duty status circles colors
    breakC: breakC ?? this.breakC,
    driveC: driveC ?? this.driveC,
    shiftC: shiftC ?? this.shiftC,
    cycleC: cycleC ?? this.cycleC,
    themeToggle: themeToggle ?? this.themeToggle,
  );

  @override
  ThemeExtension<ThemeColors> lerp(ThemeExtension<ThemeColors>? other, double t) => other is! ThemeColors
      ? this
      : ThemeColors(
          error: Color.lerp(error, other.error, t)!,
          onError: Color.lerp(onError, other.onError, t)!,
          primary: Color.lerp(primary, other.primary, t)!,
          onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
          secondary: Color.lerp(secondary, other.secondary, t)!,
          onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
          success: Color.lerp(success, other.success, t)!,
          onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
          surface: Color.lerp(surface, other.surface, t)!,
          onSurface: Color.lerp(onSurface, other.onSurface, t)!,
          tealBlue: Color.lerp(tealBlue, other.tealBlue, t)!,
          tertiary: Color.lerp(tertiary, other.tertiary, t)!,
          tertiaryBold: Color.lerp(tertiaryBold, other.tertiaryBold, t)!,
          onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,

          // Base colors
          black: Color.lerp(black, other.black, t)!,
          gray: Color.lerp(gray, other.gray, t)!,
          transparent: Color.lerp(transparent, other.transparent, t)!,
          white: Color.lerp(white, other.white, t)!,
          green: Color.lerp(green, other.green, t)!,

          // Widget-specific colors
          buttonBorder: Color.lerp(buttonBorder, other.buttonBorder, t)!,
          buttonFill: Color.lerp(buttonFill, other.buttonFill, t)!,
          divider: Color.lerp(divider, other.divider, t)!,
          primaryButtonFill: Color.lerp(primaryButtonFill, other.primaryButtonFill, t)!,
          primaryButtonBorder: Color.lerp(primaryButtonBorder, other.primaryButtonBorder, t)!,

          // text color
          text: Color.lerp(text, other.text, t)!,

          // duty status circles colors
          breakC: Color.lerp(breakC, other.breakC, t)!,
          driveC: Color.lerp(driveC, other.driveC, t)!,
          shiftC: Color.lerp(shiftC, other.shiftC, t)!,
          cycleC: Color.lerp(cycleC, other.cycleC, t)!,
          themeToggle: Color.lerp(themeToggle, other.themeToggle, t)!,
        );

  @override
  String toString() => 'ThemeColors{}';
}
