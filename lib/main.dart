import 'package:flutter/material.dart';
import 'package:fan_noises/pages/app_layout.dart';
import 'package:fan_noises/themes/app.theme.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: S.delegate.supportedLocales,

      title: 'Fan Noises',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: const AppLayout(),
    );
  }
}
