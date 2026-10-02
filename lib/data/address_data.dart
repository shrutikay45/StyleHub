import 'package:flutter/foundation.dart';
import '../models/address_model.dart';
import 'user_data.dart';

class AddressData {
  static final List<AddressItem> _addresses = [];
  static final ValueNotifier<List<AddressItem>> notifier = ValueNotifier<List<AddressItem>>([]);

  static List<AddressItem> get addresses => List.unmodifiable(_addresses);

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

  static void _syncWithUserData() {
    notifier.value = List.from(_addresses);
    final def = selectedAddress;
    if (def != null) {
      UserData.location = def.fullDisplayText;
      if (def.fullName.isNotEmpty) UserData.name = def.fullName;
      if (def.phone.isNotEmpty) UserData.phone = def.phone;
    } else {
      UserData.location = '';
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
  }
}
