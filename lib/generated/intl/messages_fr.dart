// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(name) => "Supprimer ${name} ?";

  static String m1(name) => "${name} a besoin d\'un fichier audio";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addFan": MessageLookupByLibrary.simpleMessage("Ajouter un ventilateur"),
    "addNameToFan": MessageLookupByLibrary.simpleMessage(
      "Ajoutez un nom à votre ventilateur",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "chooseAudioFile": MessageLookupByLibrary.simpleMessage(
      "Choisir un fichier audio",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
    "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
    "deleteFan": MessageLookupByLibrary.simpleMessage(
      "Supprimer le ventilateur",
    ),
    "deleteFanConfirm": m0,
    "drawerWelcome": MessageLookupByLibrary.simpleMessage(
      "Bienvenue dans Custom Fan White Noises !",
    ),
    "fanName": MessageLookupByLibrary.simpleMessage("Nom du ventilateur"),
    "fanNeedsAudio": m1,
    "homeTitle": MessageLookupByLibrary.simpleMessage("Accueil"),
    "manageFans": MessageLookupByLibrary.simpleMessage(
      "Gérer les ventilateurs",
    ),
    "privacyOptions": MessageLookupByLibrary.simpleMessage(
      "Options de confidentialité des annonces",
    ),
    "privacyOptionsUnavailable": MessageLookupByLibrary.simpleMessage(
      "Les options de confidentialité des annonces ne sont pas disponibles pour le moment",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Politique de confidentialité",
    ),
    "privacyPolicyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'ouvrir la politique de confidentialité",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
    "setTimer": MessageLookupByLibrary.simpleMessage("Régler la minuterie"),
    "timerLabel": MessageLookupByLibrary.simpleMessage("Minuterie :"),
    "unsupportedAudioFormat": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner un format audio pris en charge",
    ),
    "volumeLabel": MessageLookupByLibrary.simpleMessage("Vol :"),
    "yourFans": MessageLookupByLibrary.simpleMessage("Vos ventilateurs"),
  };
}
