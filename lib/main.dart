import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:fan_noises/pages/app_layout.dart';
import 'package:fan_noises/themes/app.theme.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Runs playback inside a mediaPlayback foreground service
  await JustAudioBackground.init(
    androidNotificationChannelId:
        'com.adan.custom_fan_white_noise.channel.audio',
    androidNotificationChannelName: 'Playback',
    androidNotificationIcon: 'drawable/ic_stat_fan',
    androidNotificationOngoing: true,
  );

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
