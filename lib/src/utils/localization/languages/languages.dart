import 'package:flutter/material.dart';

abstract class Languages {

  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get mainAppBar;

  String get labelSignup;

  String get labelSignin;

  String get labelEmail;

  String get labelForgotPassword;

  String get labelUserName;

  String get labelAuthPassword;

  String get labelSigninButton;

  String get labelSignupButton;

  String get labelSelectLanguage;

  String get labelNotes;

  String get labelPin;

  String get labelDairy;

  String get labelDoNotHaveAnAccount;

  String get labelAlreadyHaveAnAccount;

  String get labelProtectDiary;

  String get popUpLogout;

  String get popUpLanguage;

  String get appBarAddNotes;

  String get appBarEditNotes;

  String get addNoteTitle;

  String get addNoteContent;

  String get addDiaryTitle;

  String get addDiaryContent;

  String get appBarDiary;

  String get appBarEditDiary;

  String get appBarPinNotes;

  String get addList;

  String get addImage;

  String get labelPassword;

  String get addDiaryPassword;
}