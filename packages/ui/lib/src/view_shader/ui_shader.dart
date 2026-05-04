import 'dart:ui' as ui show FragmentProgram, FragmentShader;

class ShaderPaths {
  const ShaderPaths._();

  static const String circleGradient = 'packages/ui/lib/shader/circle_gradient.frag';
}

class UiShaders {
  const UiShaders._({required this.circleGradient});

  /// The instance of the shaders
  static UiShaders? _instance;

  /// Static getter for the shaders instance.
  static Future<UiShaders> get instance async => _instance ??= await _initShaders();

  /// Initializes the shaders.
  static Future<UiShaders> _initShaders() async {
    final circleGradient = (await ui.FragmentProgram.fromAsset(ShaderPaths.circleGradient)).fragmentShader();

    _instance = UiShaders._(circleGradient: circleGradient);

    return _instance!;
  }

  final ui.FragmentShader circleGradient;
}
