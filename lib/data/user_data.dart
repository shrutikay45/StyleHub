import 'package:flutter/foundation.dart';

class UserData {
  static String email = 'user@example.com';
  static String password = '';
  static String name = 'Alok Singh';
  static String phone = '+91 9876543210';
  
  static ValueNotifier<String> locationNotifier = ValueNotifier<String>('New Delhi, India');
  
  static String get location => locationNotifier.value;
  static set location(String newLocation) {
    locationNotifier.value = newLocation;
  }
}
