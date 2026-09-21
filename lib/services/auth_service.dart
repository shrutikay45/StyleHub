import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_data.dart';
import 'api_config.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  AuthResult({
    required this.success,
    required this.message,
    this.data,
  });
}

class AuthService {
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserId = 'auth_user_id';
  static const String _keyUserName = 'auth_user_name';
  static const String _keyUserEmail = 'auth_user_email';
  static const String _keyUserPhone = 'auth_user_phone';
  static const String _keyUserRole = 'auth_user_role';

  static String? _cachedAccessToken;
  static String? get accessToken => _cachedAccessToken;

  /// Check if user has an active session
  static bool get isLoggedIn => _cachedAccessToken != null && _cachedAccessToken!.isNotEmpty;

  /// Initialize session from local storage on app start
  static Future<bool> initSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedAccessToken = prefs.getString(_keyAccessToken);
      if (_cachedAccessToken != null && _cachedAccessToken!.isNotEmpty) {
        UserData.name = prefs.getString(_keyUserName) ?? 'User';
        UserData.email = prefs.getString(_keyUserEmail) ?? '';
        UserData.phone = prefs.getString(_keyUserPhone) ?? '';
        return true;
      }
    } catch (e) {
      debugPrint('Error loading saved auth session: $e');
    }
    return false;
  }

  /// Register new user with Amazon/Flipkart standard details
  static Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    // 1. Client-Side Input Sanitization & Anti-Hacking Guard
    final cleanFirstName = firstName.trim();
    final cleanLastName = lastName.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phone.trim().replaceAll(RegExp(r'\s+|-'), '');
    final cleanPassword = password.trim();

    if (cleanFirstName.isEmpty) {
      return AuthResult(success: false, message: 'Please enter your first name.');
    }
    if (cleanEmail.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(cleanEmail)) {
      return AuthResult(success: false, message: 'Please enter a valid email address.');
    }
    if (cleanPhone.isEmpty || cleanPhone.length < 10) {
      return AuthResult(success: false, message: 'Please enter a valid 10-digit mobile number.');
    }
    if (cleanPassword.length < 8) {
      return AuthResult(success: false, message: 'Password must be at least 8 characters long.');
    }

    try {
      final uri = Uri.parse(ApiConfig.register);
      final body = jsonEncode({
        'firstName': cleanFirstName,
        'lastName': cleanLastName.isNotEmpty ? cleanLastName : null,
        'email': cleanEmail,
        'phone': cleanPhone,
        'password': cleanPassword,
      });

      final response = await http
          .post(
            uri,
            headers: ApiConfig.headers(),
            body: body,
          )
          .timeout(const Duration(seconds: 40));

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          await _saveSessionFromAuthResponse(jsonBody['data']);
          return AuthResult(
            success: true,
            message: jsonBody['message'] ?? 'Account created successfully!',
            data: jsonBody['data'],
          );
        }
      }

      // Handle custom API errors (409 Conflict, 400 Bad Request, etc.)
      final errorMessage = jsonBody['message'] ?? 'Registration failed. Please try again.';
      return AuthResult(success: false, message: errorMessage);
    } on TimeoutException {
      return AuthResult(
        success: false,
        message: 'Server is starting up (Render cold start). Please try again in 10 seconds.',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'An unexpected error occurred. Please try again later.',
      );
    }
  }

  /// Login with Email or Phone + Password
  static Future<AuthResult> login({
    required String emailOrPhone,
    required String password,
  }) async {
    // 1. Client-Side Sanitization
    final cleanIdentifier = emailOrPhone.trim();
    final cleanPassword = password.trim();

    if (cleanIdentifier.isEmpty) {
      return AuthResult(success: false, message: 'Please enter your email or mobile number.');
    }
    if (cleanPassword.isEmpty) {
      return AuthResult(success: false, message: 'Please enter your password.');
    }

    try {
      final uri = Uri.parse(ApiConfig.login);
      final body = jsonEncode({
        'emailOrPhone': cleanIdentifier,
        'password': cleanPassword,
      });

      final response = await http
          .post(
            uri,
            headers: ApiConfig.headers(),
            body: body,
          )
          .timeout(const Duration(seconds: 40));

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonBody['success'] == true && jsonBody['data'] != null) {
          await _saveSessionFromAuthResponse(jsonBody['data']);
          return AuthResult(
            success: true,
            message: jsonBody['message'] ?? 'Login successful!',
            data: jsonBody['data'],
          );
        }
      }

      final errorMessage = jsonBody['message'] ?? 'Invalid credentials. Please try again.';
      return AuthResult(success: false, message: errorMessage);
    } on TimeoutException {
      return AuthResult(
        success: false,
        message: 'Server is starting up (Render cold start). Please try again in 10 seconds.',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Unable to connect to server. Please try again.',
      );
    }
  }

  /// Helper to store token & user details in SharedPreferences & UserData
  static Future<void> _saveSessionFromAuthResponse(Map<String, dynamic> authData) async {
    final prefs = await SharedPreferences.getInstance();

    final token = authData['accessToken'] as String?;
    final refreshToken = authData['refreshToken'] as String?;
    final user = authData['user'] as Map<String, dynamic>?;

    _cachedAccessToken = token;

    if (token != null) await prefs.setString(_keyAccessToken, token);
    if (refreshToken != null) await prefs.setString(_keyRefreshToken, refreshToken);

    if (user != null) {
      final id = user['id']?.toString() ?? '';
      final name = user['name']?.toString() ?? 'User';
      final email = user['email']?.toString() ?? '';
      final phone = user['phone']?.toString() ?? '';
      final role = user['role']?.toString() ?? 'CUSTOMER';

      await prefs.setString(_keyUserId, id);
      await prefs.setString(_keyUserName, name);
      await prefs.setString(_keyUserEmail, email);
      await prefs.setString(_keyUserPhone, phone);
      await prefs.setString(_keyUserRole, role);

      // Sync with global runtime UserData
      UserData.name = name;
      UserData.email = email;
      UserData.phone = phone;
    }
  }

  /// Logout current user and clear local session
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAccessToken);
      await prefs.remove(_keyRefreshToken);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserName);
      await prefs.remove(_keyUserEmail);
      await prefs.remove(_keyUserPhone);
      await prefs.remove(_keyUserRole);
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      _cachedAccessToken = null;
      UserData.name = 'Guest User';
      UserData.email = '';
      UserData.phone = '';
    }
  }
}
