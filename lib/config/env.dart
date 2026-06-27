class Env {
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get isProd => _env == 'prod';
  static bool get isDev => _env == 'dev';
}
