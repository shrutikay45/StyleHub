import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/address_data.dart';
import 'package:new_expense/data/user_data.dart';
import 'package:new_expense/models/address_model.dart';
import 'package:new_expense/services/api_config.dart';
import 'package:new_expense/services/auth_service.dart';

Future<void> showAddressDialog(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _AddressManagerModal(),
  );
}

class _AddressManagerModal extends StatefulWidget {
  const _AddressManagerModal();

  @override
  State<_AddressManagerModal> createState() => _AddressManagerModalState();
}

class _AddressManagerModalState extends State<_AddressManagerModal> {
  bool _isFormView = false;
  String? _editingId;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _houseController;
  late TextEditingController _areaController;
  late TextEditingController _pincodeController;
  late TextEditingController _cityController;

  String _selectedState = 'Delhi';
  String _selectedType = 'Home';

  static const List<String> _indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: UserData.name);
    _phoneController = TextEditingController(text: UserData.phone);
    _houseController = TextEditingController();
    _areaController = TextEditingController();
    _pincodeController = TextEditingController();
    _cityController = TextEditingController();

    _loadAddressesFromBackend();

    // If no saved addresses exist yet, open form directly
    if (AddressData.addresses.isEmpty) {
      _isFormView = true;
    }
  }

  Future<void> _loadAddressesFromBackend() async {
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
              .map((item) => AddressItem.fromJson(item))
              .toList();
          if (list.isNotEmpty) {
            AddressData.loadFromBackend(list);
            if (mounted && _isFormView && _editingId == null) {
              setState(() {
                _isFormView = false;
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading backend addresses: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _openAddForm() {
    setState(() {
      _editingId = null;
      _nameController.text = UserData.name;
      _phoneController.text = UserData.phone;
      _houseController.clear();
      _areaController.clear();
      _pincodeController.clear();
      _cityController.clear();
      _selectedState = 'Delhi';

      // Default type based on what is not yet saved
      if (!AddressData.hasType('Home')) {
        _selectedType = 'Home';
      } else if (!AddressData.hasType('Work')) {
        _selectedType = 'Work';
      } else {
        _selectedType = 'Other';
      }

      _isFormView = true;
    });
  }

  void _openEditForm(AddressItem item) {
    setState(() {
      _editingId = item.id;
      _selectedType = item.label;
      _nameController.text = item.fullName;
      _phoneController.text = item.phone;
      _houseController.text = item.houseNo;
      _areaController.text = item.area;
      _pincodeController.text = item.pincode;
      _cityController.text = item.city;
      _selectedState = _indianStates.contains(item.state) ? item.state : 'Delhi';
      _isFormView = true;
    });
  }

  void _deleteAddress(AddressItem item) {
    AddressData.deleteAddress(item.id);
    if (AuthService.isLoggedIn && !item.id.contains(RegExp(r'^\d+$'))) {
      try {
        final token = AuthService.accessToken;
        final uri = Uri.parse('${ApiConfig.addresses}/${item.id}');
        http.delete(uri, headers: ApiConfig.headers(token: token)).timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('Error deleting backend address: $e');
      }
    }
  }

  void _selectDefaultAddress(AddressItem item) async {
    AddressData.setDefaultAddress(item.id);
    if (AuthService.isLoggedIn && !item.id.contains(RegExp(r'^\d+$'))) {
      try {
        final token = AuthService.accessToken;
        final uri = Uri.parse('${ApiConfig.addresses}/${item.id}/default');
        await http.patch(uri, headers: ApiConfig.headers(token: token)).timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('Error setting default backend address: $e');
      }
    }
  }

  void _saveAddress() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final house = _houseController.text.trim();
      final area = _areaController.text.trim();
      final city = _cityController.text.trim();
      final state = _selectedState;
      final pincode = _pincodeController.text.trim();

      var addressItem = AddressItem(
        id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        label: _selectedType,
        fullName: name,
        phone: phone,
        houseNo: house,
        area: area,
        city: city,
        state: state,
        pincode: pincode,
        isDefault: true,
      );

      // Direct live DB Sync if user is logged in
      if (AuthService.isLoggedIn) {
        try {
          final token = AuthService.accessToken;
          final isEdit = _editingId != null && !_editingId!.contains(RegExp(r'^\d+$'));
          final uri = isEdit
              ? Uri.parse('${ApiConfig.addresses}/$_editingId')
              : Uri.parse(ApiConfig.addresses);
          final body = jsonEncode({
            'label': _selectedType,
            'fullName': name,
            'phone': phone,
            'addressLine1': house,
            'addressLine2': area,
            'city': city,
            'state': state,
            'zipCode': pincode,
            'country': 'India',
            'isDefault': true,
          });

          final res = isEdit
              ? await http.put(uri, headers: ApiConfig.headers(token: token), body: body).timeout(const Duration(seconds: 10))
              : await http.post(uri, headers: ApiConfig.headers(token: token), body: body).timeout(const Duration(seconds: 10));

          if (res.statusCode == 200 || res.statusCode == 201) {
            final jsonBody = jsonDecode(res.body);
            if (jsonBody['success'] == true && jsonBody['data'] != null) {
              addressItem = AddressItem.fromJson(jsonBody['data'] as Map<String, dynamic>);
              debugPrint('Saved to backend DB with id: ${addressItem.id}');
            }
          }
        } catch (e) {
          debugPrint('Error syncing address to backend: $e');
        }
      }

      if (_editingId != null) {
        AddressData.updateAddress(addressItem);
      } else {
        AddressData.addAddress(addressItem);
      }

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _editingId != null ? 'Address updated in database!' : 'Address saved to database & set for delivery!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0F8A5F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AddressData.notifier,
      builder: (context, _) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: _isFormView ? _buildFormView() : _buildListView(),
        );
      },
    );
  }

  // ===========================================================================
  // 1. SAVED ADDRESSES LIST VIEW (COMPACT & MODERN)
  // ===========================================================================
  Widget _buildListView() {
    final addresses = AddressData.addresses;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Clean Header (Title + Close only)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 12, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Delivery Addresses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                    Text(
                      'Select an address for order delivery',
                      style: TextStyle(fontSize: 11, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.dark, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        // Compact Address Cards List
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final item = addresses[index];
              final isSelected = item.isDefault;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFF7F9) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _selectDefaultAddress(item);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Type Tag + DEFAULT status + Edit/Delete Actions
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getTypeIcon(item.label),
                                    size: 11,
                                    color: isSelected ? Colors.white : AppColors.dark,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    item.label.toUpperCase(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppColors.dark,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 9.5,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              const Text(
                                '• DEFAULT',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                            const Spacer(),
                            // Edit button
                            InkWell(
                              onTap: () => _openEditForm(item),
                              borderRadius: BorderRadius.circular(6),
                              child: const Padding(
                                padding: EdgeInsets.all(3),
                                child: Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                              ),
                            ),
                            // Delete button
                            if (addresses.length > 1) ...[
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => _deleteAddress(item),
                                borderRadius: BorderRadius.circular(6),
                                child: const Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Name & Phone
                        Text(
                          '${item.fullName}   |   +91 ${item.phone}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 3),

                        // Formatted Address line
                        Text(
                          item.formattedAddress,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF555555),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Selection Row
                        Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? AppColors.primary : Colors.grey.shade400,
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isSelected ? 'Delivering to this address' : 'Tap to select this address',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? AppColors.primary : AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom + Add New Address Action Bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: _openAddForm,
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 17),
              label: const Text(
                '+ ADD NEW ADDRESS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: const Color(0xFFFFF7F9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 2. ADD / EDIT ADDRESS FORM VIEW
  // ===========================================================================
  Widget _buildFormView() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = _editingId != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drag handle
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 12, 12),
          child: Row(
            children: [
              if (AddressData.addresses.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.dark),
                  onPressed: () {
                    setState(() {
                      _isFormView = false;
                    });
                  },
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Address' : 'Add New Address',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Enter shipping details for delivery',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.dark),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Form Fields
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Save As Type Chips (Home / Work / Other)
                  const Text(
                    'SAVE ADDRESS AS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildTypeChip('Home', Icons.home_outlined),
                      const SizedBox(width: 10),
                      _buildTypeChip('Work', Icons.business_outlined),
                      const SizedBox(width: 10),
                      _buildTypeChip('Other', Icons.location_on_outlined),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Contact Details Section
                  const Text(
                    'CONTACT DETAILS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter recipient name' : null,
                    decoration: _inputDecoration('Full Name *', Icons.person_outline),
                  ),
                  const SizedBox(height: 12),
                  // Mobile Number with 10-digit constraint
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Please enter 10-digit mobile number';
                      if (val.trim().length != 10) return 'Mobile number must be exactly 10 digits';
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(val.trim())) return 'Enter valid Indian mobile number';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Mobile Number *',
                      labelStyle: const TextStyle(fontSize: 13, color: AppColors.grey, fontWeight: FontWeight.w500),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone_outlined, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              '+91',
                              style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Container(width: 1, height: 18, color: const Color(0xFFCBD5E1)),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Address Details Section
                  const Text(
                    'ADDRESS DETAILS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _houseController,
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter Flat/House No.' : null,
                    decoration: _inputDecoration('Flat, House No., Building *', Icons.home_work_outlined),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _areaController,
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter Area/Street/Locality' : null,
                    decoration: _inputDecoration('Area, Street, Sector, Locality *', Icons.explore_outlined),
                  ),
                  const SizedBox(height: 12),

                  // Pincode (6-digit constraint) & City (Row)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Enter 6-digit PIN';
                            if (val.trim().length != 6) return 'Must be 6 digits';
                            return null;
                          },
                          decoration: _inputDecoration('PIN Code *', Icons.pin_drop_outlined),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          validator: (val) => (val == null || val.trim().isEmpty) ? 'Enter City' : null,
                          decoration: _inputDecoration('City / District *', Icons.location_city_outlined),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // State Dropdown (All Indian States & UTs)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedState,
                    isExpanded: true,
                    decoration: _inputDecoration('State *', Icons.map_outlined),
                    items: _indianStates.map((st) {
                      return DropdownMenuItem<String>(
                        value: st,
                        child: Text(
                          st,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedState = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 26),

                  // Save & Deliver Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _saveAddress,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      label: Text(
                        isEditing ? 'UPDATE & DELIVER HERE' : 'SAVE & DELIVER HERE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type, IconData icon) {
    final isSelected = _selectedType == type;
    final isAlreadySaved = !isSelected && _editingId == null && (type == 'Home' || type == 'Work') && AddressData.hasType(type);

    if (isAlreadySaved) {
      // If Home/Work is already saved and we are adding a new address, show as already existing badge
      return Expanded(
        child: Opacity(
          opacity: 0.45,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 15, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '$type (Saved)',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.dark,
              ),
              const SizedBox(width: 6),
              Text(
                type,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13, color: AppColors.grey, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.business_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }
}
