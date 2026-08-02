import 'package:flutter/foundation.dart';

class Env {
  static bool get isProd => kReleaseMode;
  static bool get isDev => !kReleaseMode;
}
