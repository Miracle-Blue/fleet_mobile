/// Origin Code maybe change if type changed manually or automatically. manual:2, auto:1
library;

enum LogsType implements Comparable<LogsType> {
  /// Login log type: 5, code: 1, origin: 2
  login(
    // Login log type: 5, code: 1, origin: 2
    eventType: 5,
    eventCode: 1,
    originCode: 2,
    type: 'login',
  ),

  /// Logout log type: 5, code: 2, origin: 2
  logout(
    // Logout log type: 5, code: 2, origin: 2
    eventType: 5,
    eventCode: 2,
    originCode: 2,
    type: 'logout',
  ),

  /// Off duty log type: 1, code: 1, origin: 2
  off(
    // Off duty log type: 1, code: 1, origin: 2
    eventType: 1,
    eventCode: 1,
    originCode: 2,
    type: 'off_duty',
  ),

  /// Sleep break log type: 1, code: 2, origin: 2
  sb(
    // Sleep break log type: 1, code: 2, origin: 2
    eventType: 1,
    eventCode: 2,
    originCode: 2,
    type: 'sleep_break',
  ),

  /// On duty log type: 1, code: 4, origin: 2
  on(
    // On duty log type: 1, code: 4, origin: 2
    eventType: 1,
    eventCode: 4,
    originCode: 2, // TODO(Miracle): it changes to 1 in the auto mode
    type: 'on_duty',
  ),

  /// Drive log type: 1, code: 3, origin: 1
  dr(
    // Drive log type: 1, code: 3, origin: 1
    eventType: 1,
    eventCode: 3,
    originCode: 1,
    type: 'drive',
  ),

  /// Intermediate drive log type: 2, code: 1, origin: 1
  intermediate(
    // Intermediate drive log type: 2, code: 1, origin: 1
    eventType: 2,
    eventCode: 1,
    originCode: 1,
    type: 'intermediate_drive',
  ),

  /// Intermediate personal conveyance log type: 2, code: 2, origin: 1
  intermediatePC(
    // Intermediate personal conveyance log type: 2, code: 2, origin: 1
    eventType: 2,
    eventCode: 2,
    originCode: 1,
    type: 'intermediate_personal_conveyance',
  ),

  /// Personal conveyance log type: 3, code: 1, origin: 2
  pc(
    // Personal conveyance log type: 3, code: 1, origin: 2
    eventType: 3,
    eventCode: 1,
    originCode: 2,
    type: 'personal_conveyance',
  ),

  /// Yard move log type: 3, code: 2, origin: 2
  ym(
    // Yard move log type: 3, code: 2, origin: 2
    eventType: 3,
    eventCode: 2,
    originCode: 2,
    type: 'yard_move',
  ),

  /// Wait log type: 3, code: 0, origin: 2
  wt(
    // Wait log type: 3, code: 0, origin: 2
    eventType: 3,
    eventCode: 0,
    originCode: 2,
    type: 'wait',
  ),

  /// Certify log type: 4, code: 1, origin: 2
  certify(
    // Certify log type: 4, code: 1, origin: 2
    eventType: 4,
    eventCode: 1,
    originCode: 2,
    type: 'certify',
  ),

  /// Power on log type: 6, code: 1, origin: 1
  powerOn(
    // Power on log type: 6, code: 1, origin: 1
    eventType: 6,
    eventCode: 1,
    originCode: 1,
    type: 'power_on',
  ),

  /// Power off log type: 6, code: 3, origin: 1
  powerOff(
    // Power off log type: 6, code: 3, origin: 1
    eventType: 6,
    eventCode: 3,
    originCode: 1,
    type: 'power_off',
  ),

  /// Personal conveyance power on log type: 6, code: 2, origin: 1
  pcPowerOn(
    // Personal conveyance power on log type: 6, code: 2, origin: 1
    eventType: 6,
    eventCode: 2,
    originCode: 1,
    type: 'pc_power_on',
  ),

  /// Personal conveyance power off log type: 6, code: 4, origin: 1
  pcPowerOff(
    // Personal conveyance power off log type: 6, code: 4, origin: 1
    eventType: 6,
    eventCode: 4,
    originCode: 1,
    type: 'pc_power_off',
  );

  const LogsType({required this.eventType, required this.eventCode, required this.originCode, required this.type});

  /// Creates a new instance of [LogsType] from a given string.
  static LogsType fromValue(String? value, {LogsType? fallback}) => switch (value) {
    'login' => login,
    'logout' => logout,
    'off_duty' => off,
    'sleep_break' => sb,
    'on_duty' => on,
    'drive' => dr,
    'intermediate_drive' => intermediate,
    'intermediate_personal_conveyance' => intermediatePC,
    'personal_conveyance' => pc,
    'yard_move' => ym,
    'wait' => wt,
    'certify' => certify,
    'power_on' => powerOn,
    'power_off' => powerOff,
    'pc_power_on' => pcPowerOn,
    'pc_power_off' => pcPowerOff,
    _ => fallback ?? (throw ArgumentError.value(value, 'value', 'Invalid logs type')),
  };

  static LogsType fromEventTypeAndCode({required int eventType, required int eventCode}) =>
      switch ((eventType, eventCode)) {
        (5, 1) => login,
        (5, 2) => logout,
        (1, 1) => off,
        (1, 2) => sb,
        (1, 4) => on,
        (1, 3) => dr,
        (2, 1) => intermediate,
        (2, 2) => intermediatePC,
        (3, 1) => pc,
        (3, 2) => ym,
        (3, 0) => wt,
        (4, 1) => certify,
        (6, 1) => powerOn,
        (6, 3) => powerOff,
        (6, 2) => pcPowerOn,
        (6, 4) => pcPowerOff,
        _ => throw ArgumentError.value(
          (eventType, eventCode),
          'eventType and eventCode',
          'Invalid event type and event code',
        ),
      };

  final int eventType, eventCode, originCode;
  final String type;

  /// Pattern matching
  T map<T>({
    required T Function() login,
    required T Function() logout,
    required T Function() off,
    required T Function() sb,
    required T Function() on,
    required T Function() dr,
    required T Function() intermediate,
    required T Function() intermediatePC,
    required T Function() pc,
    required T Function() ym,
    required T Function() wt,
    required T Function() certify,
    required T Function() powerOn,
    required T Function() powerOff,
    required T Function() pcPowerOn,
    required T Function() pcPowerOff,
  }) => switch (this) {
    LogsType.login => login(),
    LogsType.logout => logout(),
    LogsType.off => off(),
    LogsType.sb => sb(),
    LogsType.on => on(),
    LogsType.dr => dr(),
    LogsType.intermediate => intermediate(),
    LogsType.intermediatePC => intermediatePC(),
    LogsType.pc => pc(),
    LogsType.ym => ym(),
    LogsType.wt => wt(),
    LogsType.certify => certify(),
    LogsType.powerOn => powerOn(),
    LogsType.powerOff => powerOff(),
    LogsType.pcPowerOn => pcPowerOn(),
    LogsType.pcPowerOff => pcPowerOff(),
  };

  /// Pattern matching
  T maybeMap<T>({
    required T Function() orElse,
    T Function()? login,
    T Function()? logout,
    T Function()? off,
    T Function()? sb,
    T Function()? on,
    T Function()? dr,
    T Function()? intermediate,
    T Function()? intermediatePC,
    T Function()? pc,
    T Function()? ym,
    T Function()? wt,
    T Function()? certify,
    T Function()? powerOn,
    T Function()? powerOff,
    T Function()? pcPowerOn,
    T Function()? pcPowerOff,
  }) => map<T>(
    login: login ?? orElse,
    logout: logout ?? orElse,
    off: off ?? orElse,
    sb: sb ?? orElse,
    on: on ?? orElse,
    dr: dr ?? orElse,
    intermediate: intermediate ?? orElse,
    intermediatePC: intermediatePC ?? orElse,
    pc: pc ?? orElse,
    ym: ym ?? orElse,
    wt: wt ?? orElse,
    certify: certify ?? orElse,
    powerOn: powerOn ?? orElse,
    powerOff: powerOff ?? orElse,
    pcPowerOn: pcPowerOn ?? orElse,
    pcPowerOff: pcPowerOff ?? orElse,
  );

  /// Pattern matching
  T? maybeMapOrNull<T>({
    T Function()? login,
    T Function()? logout,
    T Function()? off,
    T Function()? sb,
    T Function()? on,
    T Function()? dr,
    T Function()? intermediate,
    T Function()? intermediatePC,
    T Function()? pc,
    T Function()? ym,
    T Function()? wt,
    T Function()? certify,
    T Function()? powerOn,
    T Function()? powerOff,
    T Function()? pcPowerOn,
    T Function()? pcPowerOff,
  }) => maybeMap<T?>(
    orElse: () => null,
    login: login,
    logout: logout,
    off: off,
    sb: sb,
    on: on,
    dr: dr,
    intermediate: intermediate,
    intermediatePC: intermediatePC,
    pc: pc,
    ym: ym,
    wt: wt,
    certify: certify,
    powerOn: powerOn,
    powerOff: powerOff,
    pcPowerOn: pcPowerOn,
    pcPowerOff: pcPowerOff,
  );

  bool get isLogin => this == login;
  bool get isLogout => this == logout;
  bool get isOff => this == off;
  bool get isSb => this == sb;
  bool get isOn => this == on;
  bool get isDrive => this == dr;
  bool get isIntermediate => this == intermediate;
  bool get isIntermediatePC => this == intermediatePC;
  bool get isPc => this == pc;
  bool get isYm => this == ym;
  bool get isWait => this == wt;
  bool get isCertify => this == certify;
  bool get isPowerOn => this == powerOn;
  bool get isPowerOff => this == powerOff;
  bool get isPcPowerOn => this == pcPowerOn;
  bool get isPcPowerOff => this == pcPowerOff;

  @override
  int compareTo(LogsType other) => name.compareTo(other.name);

  @override
  String toString() => 'LogsType(eventType: $eventType, eventCode: $eventCode, originCode: $originCode, type: $type)';
}
