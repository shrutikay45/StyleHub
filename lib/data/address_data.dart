import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import '../services/api_config.dart';
import '../services/auth_service.dart';
import 'user_data.dart';

class AddressData {
  static const String _keyAddresses = 'stylehub_saved_addresses';
  static final List<AddressItem> _addresses = [];
  static final ValueNotifier<List<AddressItem>> notifier = ValueNotifier<List<AddressItem>>([]);

  static List<AddressItem> get addresses => List.unmodifiable(_addresses);

  /// Initialize and load saved addresses from SharedPreferences and Backend
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(_keyAddresses);
      if (savedJson != null && savedJson.isNotEmpty) {
        final decoded = jsonDecode(savedJson);
        if (decoded is List) {
          _addresses.clear();
          _addresses.addAll(decoded.map((item) => AddressItem.fromJson(item as Map<String, dynamic>)));
          if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
            _addresses.first.isDefault = true;
          }
          _syncWithUserData(saveLocal: false);
          debugPrint('AddressData: Restored ${_addresses.length} addresses from local storage.');
        }
      }
    } catch (e) {
      debugPrint('Error restoring saved addresses from local storage: $e');
    }

    // Also fetch fresh addresses from backend if user is logged in
    if (AuthService.isLoggedIn) {
      syncWithBackend();
    }
  }

  /// Fetch latest addresses from Backend DB
  static Future<void> syncWithBackend() async {
    if (!AuthService.isLoggedIn) return;
    try {
      final token = AuthService.accessToken;
      final uri = Uri.parse(ApiConfig.addresses);
      final response = await http
          .get(uri, headers: ApiConfig.headers(token: token))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] is List) {
          final list = (jsonBody['data'] as List)
              .map((item) => AddressItem.fromJson(item as Map<String, dynamic>))
              .toList();
          if (list.isNotEmpty) {
            loadFromBackend(list);
            debugPrint('AddressData: Synced ${list.length} addresses from backend DB.');
          }
        }
      }
    } catch (e) {
      debugPrint('Error syncing addresses from backend: $e');
    }
  }

  static bool hasType(String type, {String? excludeId}) {
    return _addresses.any((a) => a.label.toLowerCase() == type.toLowerCase() && a.id != excludeId);
  }

  static AddressItem? get selectedAddress {
    if (_addresses.isEmpty) return null;
    return _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
  }

  static void addAddress(AddressItem address) {
    if (_addresses.isEmpty || address.isDefault) {
      for (var a in _addresses) {
        a.isDefault = false;
      }
      address.isDefault = true;
    }
    _addresses.add(address);
    _syncWithUserData();
  }

  static void updateAddress(AddressItem updated) {
    final index = _addresses.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      if (updated.isDefault) {
        for (var a in _addresses) {
          a.isDefault = false;
        }
      }
      _addresses[index] = updated;
      _syncWithUserData();
    }
  }

  static void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses.first.isDefault = true;
    }
    _syncWithUserData();
  }

  static void setDefaultAddress(String id) {
    for (var a in _addresses) {
      a.isDefault = (a.id == id);
    }
    _syncWithUserData();
  }

  static void _syncWithUserData({bool saveLocal = true}) {
    notifier.value = List.from(_addresses);
    final def = selectedAddress;
    if (def != null) {
      UserData.location = def.fullDisplayText;
      if (def.fullName.isNotEmpty) UserData.name = def.fullName;
      if (def.phone.isNotEmpty) UserData.phone = def.phone;
    } else {
      UserData.location = '';
    }

    if (saveLocal) {
      _saveToLocalStorage();
    }
  }

  static Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _addresses.map((a) => a.toJson()).toList();
      await prefs.setString(_keyAddresses, jsonEncode(jsonList));
      debugPrint('AddressData: Saved ${_addresses.length} addresses to local storage.');
    } catch (e) {
      debugPrint('Error saving addresses to local storage: $e');
    }
  }

  static void loadFromBackend(List<AddressItem> items) {
    _addresses.clear();
    _addresses.addAll(items);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses.first.isDefault = true;
    }
    _syncWithUserData();
  }

  static void clear() {
    _addresses.clear();
    notifier.value = [];
    UserData.location = '';
    SharedPreferences.getInstance().then((prefs) => prefs.remove(_keyAddresses));
  }
}
