// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Delete ${name}?";

  static String m1(name) => "${name} needs an audio file";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addFan": MessageLookupByLibrary.simpleMessage("Add fan"),
    "addNameToFan": MessageLookupByLibrary.simpleMessage(
      "Add a name to your fan",
    ),
    "audioSaveErrorStorageFull": MessageLookupByLibrary.simpleMessage(
      "Not enough storage space to save this file. Free up some space and try again",
    ),
    "audioSaveErrorUnknown": MessageLookupByLibrary.simpleMessage(
      "Something went wrong saving the audio file. Please try again",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "chooseAudioFile": MessageLookupByLibrary.simpleMessage(
      "Choose audio file",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteFan": MessageLookupByLibrary.simpleMessage("Delete Fan"),
    "deleteFanConfirm": m0,
    "drawerWelcome": MessageLookupByLibrary.simpleMessage(
      "Welcome to Custom Fan White Noises!",
    ),
    "fanName": MessageLookupByLibrary.simpleMessage("Fan name"),
    "fanNameTaken": MessageLookupByLibrary.simpleMessage(
      "A fan with this name already exists",
    ),
    "fanNeedsAudio": m1,
    "homeTitle": MessageLookupByLibrary.simpleMessage("Home"),
    "largeAudioFileWarning": MessageLookupByLibrary.simpleMessage(
      "This file is over 50MB and may take longer to save",
    ),
    "manageFans": MessageLookupByLibrary.simpleMessage("Manage Fans"),
    "noFileExtension": MessageLookupByLibrary.simpleMessage(
      "Please select a file with a valid extension",
    ),
    "privacyOptions": MessageLookupByLibrary.simpleMessage(
      "Ad privacy options",
    ),
    "privacyOptionsUnavailable": MessageLookupByLibrary.simpleMessage(
      "Ad privacy options are not available right now",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
    "privacyPolicyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Could not open the privacy policy",
    ),
    "renameFanError": MessageLookupByLibrary.simpleMessage(
      "Could not rename this fan. Please try again",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "setTimer": MessageLookupByLibrary.simpleMessage("Set timer"),
    "timerLabel": MessageLookupByLibrary.simpleMessage("Timer:"),
    "unsupportedAudioFormat": MessageLookupByLibrary.simpleMessage(
      "Please select a supported audio format",
    ),
    "volumeLabel": MessageLookupByLibrary.simpleMessage("Vol:"),
    "yourFans": MessageLookupByLibrary.simpleMessage("Your fans"),
  };
}
