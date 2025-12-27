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

  /// `Tasks`
  String get appTitle {
    return Intl.message(
      'Tasks',
      name: 'appTitle',
      desc: 'Application title',
      args: [],
    );
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: 'Home page title',
      args: [],
    );
  }

  /// `Connection`
  String get loginTitle {
    return Intl.message('Connection', name: 'loginTitle', desc: '', args: []);
  }

  /// `Log in`
  String get loginBtn {
    return Intl.message('Log in', name: 'loginBtn', desc: '', args: []);
  }

  /// `Insert username`
  String get loginUsername {
    return Intl.message(
      'Insert username',
      name: 'loginUsername',
      desc: '',
      args: [],
    );
  }

  /// `Insert password`
  String get loginPassword {
    return Intl.message(
      'Insert password',
      name: 'loginPassword',
      desc: '',
      args: [],
    );
  }

  /// `Consultation`
  String get consultationTitle {
    return Intl.message(
      'Consultation',
      name: 'consultationTitle',
      desc: 'Consultation page title',
      args: [],
    );
  }

  /// `Creation`
  String get creationTitle {
    return Intl.message(
      'Creation',
      name: 'creationTitle',
      desc: 'Creation page title',
      args: [],
    );
  }

  /// `Sign Up`
  String get inscriptionTitle {
    return Intl.message(
      'Sign Up',
      name: 'inscriptionTitle',
      desc: 'Sign up page title',
      args: [],
    );
  }

  /// `No tasks`
  String get noTasks {
    return Intl.message(
      'No tasks',
      name: 'noTasks',
      desc: 'Message when there are no tasks',
      args: [],
    );
  }

  /// `Deadline:`
  String get deadline {
    return Intl.message('Deadline:', name: 'deadline', desc: '', args: []);
  }

  /// `Progress:`
  String get progress {
    return Intl.message('Progress:', name: 'progress', desc: '', args: []);
  }

  /// `Time:`
  String get timeElapsed {
    return Intl.message('Time:', name: 'timeElapsed', desc: '', args: []);
  }

  /// `No Internet Connection`
  String get noInternetTitle {
    return Intl.message(
      'No Internet Connection',
      name: 'noInternetTitle',
      desc: 'No internet dialog title',
      args: [],
    );
  }

  /// `Please check your internet connection and try again.`
  String get noInternetMessage {
    return Intl.message(
      'Please check your internet connection and try again.',
      name: 'noInternetMessage',
      desc: 'No internet dialog message',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: 'OK button', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: 'Retry button', args: []);
  }

  /// `No image available`
  String get noImageAvailable {
    return Intl.message(
      'No image available',
      name: 'noImageAvailable',
      desc: 'Message when no image is available',
      args: [],
    );
  }

  /// `Add an image`
  String get addImage {
    return Intl.message(
      'Add an image',
      name: 'addImage',
      desc: 'Add image button',
      args: [],
    );
  }

  /// `Save changes`
  String get saveChanges {
    return Intl.message(
      'Save changes',
      name: 'saveChanges',
      desc: 'Save changes button',
      args: [],
    );
  }

  /// `Progress:`
  String get advancement {
    return Intl.message('Progress:', name: 'advancement', desc: '', args: []);
  }

  /// `Add a name`
  String get addName {
    return Intl.message(
      'Add a name',
      name: 'addName',
      desc: 'Add name hint',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: 'Name label', args: []);
  }

  /// `Choose Date`
  String get chooseDate {
    return Intl.message(
      'Choose Date',
      name: 'chooseDate',
      desc: 'Choose date button',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: 'Add button', args: []);
  }

  /// `Create a username`
  String get createUsername {
    return Intl.message(
      'Create a username',
      name: 'createUsername',
      desc: 'Create username hint',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: 'Username label',
      args: [],
    );
  }

  /// `Create a password`
  String get createPassword {
    return Intl.message(
      'Create a password',
      name: 'createPassword',
      desc: 'Create password hint',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password label',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: 'Confirm password hint/label',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: 'Create account button',
      args: [],
    );
  }

  /// `Username is too short`
  String get errorShortMsg {
    return Intl.message(
      'Username is too short',
      name: 'errorShortMsg',
      desc: 'Error when username is too short',
      args: [],
    );
  }

  /// `Username is too long`
  String get errorLongMsg {
    return Intl.message(
      'Username is too long',
      name: 'errorLongMsg',
      desc: 'Error when username is too long',
      args: [],
    );
  }

  /// `Username already taken`
  String get errorExisteMsg {
    return Intl.message(
      'Username already taken',
      name: 'errorExisteMsg',
      desc: 'Error when username already exists',
      args: [],
    );
  }

  /// `Password is too short`
  String get errorShortMsgPass {
    return Intl.message(
      'Password is too short',
      name: 'errorShortMsgPass',
      desc: 'Error when password is too short',
      args: [],
    );
  }

  /// `Password is too long`
  String get errorLongMsgPass {
    return Intl.message(
      'Password is too long',
      name: 'errorLongMsgPass',
      desc: 'Error when password is too long',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get errorNotMatchMsg {
    return Intl.message(
      'Passwords do not match',
      name: 'errorNotMatchMsg',
      desc: 'Error when passwords don\'t match',
      args: [],
    );
  }

  /// `There was an error`
  String get errorUnknown {
    return Intl.message(
      'There was an error',
      name: 'errorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Menu of`
  String get menuTitle {
    return Intl.message('Menu of', name: 'menuTitle', desc: '', args: []);
  }

  /// `Add task`
  String get addTask {
    return Intl.message('Add task', name: 'addTask', desc: '', args: []);
  }

  /// `Receive notifications`
  String get receiveNotifs {
    return Intl.message(
      'Receive notifications',
      name: 'receiveNotifs',
      desc: '',
      args: [],
    );
  }

  /// `Test notification`
  String get testNotif {
    return Intl.message(
      'Test notification',
      name: 'testNotif',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message('Disconnect', name: 'disconnect', desc: '', args: []);
  }

  /// `Delete task`
  String get deleteConfirmationTitle {
    return Intl.message(
      'Delete task',
      name: 'deleteConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this task?`
  String get deleteConfirmationMessage {
    return Intl.message(
      'Are you sure you want to delete this task?',
      name: 'deleteConfirmationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Task deleted successfully`
  String get taskDeleted {
    return Intl.message(
      'Task deleted successfully',
      name: 'taskDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting task`
  String get deletionError {
    return Intl.message(
      'Error deleting task',
      name: 'deletionError',
      desc: '',
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
