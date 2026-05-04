import 'dart:async' show runZonedGuarded;

import 'package:logbook/logbook.dart';
import 'package:ui/ui.dart';

import 'src/common/dependency/initialization/initialization.dart';
import 'src/common/dependency/widget/dependencies_scope.dart';
import 'src/common/dependency/widget/initialization_failed_app.dart';
import 'src/common/dependency/widget/splash_screen.dart';
import 'src/common/widget/app.dart';

@pragma('vm:entry-point')
void main([List<String>? args]) => runZonedGuarded<Future<void>>(() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  final initializationProgress = ValueNotifier<({int progress, String message})>((progress: 0, message: ''));
  final splashGradient = (await UiShaders.instance).circleGradient;

  runApp(
    DependenciesScope(
      initialization: $initializeApp(
        binding: binding,
        onProgress: (progress, message) => initializationProgress.value = (progress: progress, message: message),
        orientations: [.portraitUp, .portraitDown, .landscapeLeft, .landscapeRight],
      ),
      splashScreen: SplashScreen(progress: initializationProgress, gradient: splashGradient),
      child: const App(),
      errorBuilder: (error, stackTrace) => InitializationFailedApp(
        error: error,
        stackTrace: stackTrace ?? StackTrace.current,
        onRetryInitialization: main,
      ),
    ),
  );
}, l.s);
