// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: 'Home page title (drawer + manage page button)',
      args: [],
    );
  }

  /// `Manage Fans`
  String get manageFans {
    return Intl.message(
      'Manage Fans',
      name: 'manageFans',
      desc: 'Drawer entry to open the fan management page',
      args: [],
    );
  }

  /// `Welcome to Custom Fan White Noises!`
  String get drawerWelcome {
    return Intl.message(
      'Welcome to Custom Fan White Noises!',
      name: 'drawerWelcome',
      desc: 'Drawer header greeting',
      args: [],
    );
  }

  /// `Your fans`
  String get yourFans {
    return Intl.message(
      'Your fans',
      name: 'yourFans',
      desc: 'Heading of the manage fans page',
      args: [],
    );
  }

  /// `Add fan`
  String get addFan {
    return Intl.message(
      'Add fan',
      name: 'addFan',
      desc: 'Add fan dialog title',
      args: [],
    );
  }

  /// `Fan name`
  String get fanName {
    return Intl.message(
      'Fan name',
      name: 'fanName',
      desc: 'Fan name text field label',
      args: [],
    );
  }

  /// `Choose audio file`
  String get chooseAudioFile {
    return Intl.message(
      'Choose audio file',
      name: 'chooseAudioFile',
      desc: 'Button to pick an audio file for a custom fan',
      args: [],
    );
  }

  /// `Please select a supported audio format`
  String get unsupportedAudioFormat {
    return Intl.message(
      'Please select a supported audio format',
      name: 'unsupportedAudioFormat',
      desc: 'Error when the picked file is not a supported audio format',
      args: [],
    );
  }

  /// `Add a name to your fan`
  String get addNameToFan {
    return Intl.message(
      'Add a name to your fan',
      name: 'addNameToFan',
      desc: 'Error when the fan name is empty',
      args: [],
    );
  }

  /// `{name} needs an audio file`
  String fanNeedsAudio(Object name) {
    return Intl.message(
      '$name needs an audio file',
      name: 'fanNeedsAudio',
      desc: 'Error when a fan has no audio file selected',
      args: [name],
    );
  }

  /// `Delete Fan`
  String get deleteFan {
    return Intl.message(
      'Delete Fan',
      name: 'deleteFan',
      desc: 'Delete fan confirmation dialog title',
      args: [],
    );
  }

  /// `Delete {name}?`
  String deleteFanConfirm(Object name) {
    return Intl.message(
      'Delete $name?',
      name: 'deleteFanConfirm',
      desc: 'Delete fan confirmation message',
      args: [name],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: 'Save button', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel button',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: 'Delete button',
      args: [],
    );
  }

  /// `Set timer`
  String get setTimer {
    return Intl.message(
      'Set timer',
      name: 'setTimer',
      desc: 'Timer button and timer picker title',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Confirm button',
      args: [],
    );
  }

  /// `Vol:`
  String get volumeLabel {
    return Intl.message(
      'Vol:',
      name: 'volumeLabel',
      desc: 'Volume label prefix',
      args: [],
    );
  }

  /// `Timer:`
  String get timerLabel {
    return Intl.message(
      'Timer:',
      name: 'timerLabel',
      desc: 'Remaining timer label prefix',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
