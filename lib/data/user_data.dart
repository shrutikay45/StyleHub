import 'package:flutter/foundation.dart';

class UserData {
  static final ValueNotifier<String> nameNotifier = ValueNotifier<String>('');
  static final ValueNotifier<String> emailNotifier = ValueNotifier<String>('');
  static final ValueNotifier<String> phoneNotifier = ValueNotifier<String>('');
  static final ValueNotifier<String> locationNotifier = ValueNotifier<String>('');

  static String get name => nameNotifier.value;
  static set name(String newName) {
    nameNotifier.value = newName;
  }

  static String get email => emailNotifier.value;
  static set email(String newEmail) {
    emailNotifier.value = newEmail;
  }

  static String get phone => phoneNotifier.value;
  static set phone(String newPhone) {
    phoneNotifier.value = newPhone;
  }

  static String get location => locationNotifier.value;
  static set location(String newLocation) {
    locationNotifier.value = newLocation;
  }

  static void clear() {
    name = '';
    email = '';
    phone = '';
    location = '';
  }
}
