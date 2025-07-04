import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:open_learning/utils/consts.dart';
import 'package:open_learning/utils/token_manager.dart';

class AuthService {
  //
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Sign up without OTP
  Future<Map<String, dynamic>> signUpWithoutOtp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signUpWithoutOtp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save token if login is successful
        if (data['token'] != null) {
          await TokenManager.saveToken(data['token']);
        }
      }

      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'data': data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token if verification is successful
        if (data['token'] != null) {
          await TokenManager.saveToken(data['token']);
        }
      }

      return {
        'success': response.statusCode == 200,
        'data': data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/loginStudent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token if login is successful
        if (data['token'] != null) {
          await TokenManager.saveToken(data['token']);
        }
      }

      return {
        'success': response.statusCode == 200,
        'data': data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Change Password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'error': 'No authentication token found',
          'statusCode': 401,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/changePassword'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      return {
        'success': response.statusCode == 200,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
          'otp': otp,
        }),
      );

      return {
        'success': response.statusCode == 200,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgotPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return {
        'success': response.statusCode == 200,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'error': 'No authentication token found',
          'statusCode': 401,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Clear token regardless of response
      await TokenManager.clearToken();

      return {
        'success': response.statusCode == 200,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      // Clear token even if request fails
      await TokenManager.clearToken();
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Check if user is authenticated
  Future<Map<String, dynamic>> checkToken() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'error': 'No authentication token found',
          'statusCode': 401,
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/CheckToken'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return {
        'success': response.statusCode == 200,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Update Account
  Future<Map<String, dynamic>> updateAccount({
    required String firstName,
    required String lastName,
    required String phone,
    required String country,
    String? password,
    String? gender,
    String? birthday,
    String? birthPlace,
  }) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        return {
          'success': false,
          'error': 'No authentication token found',
          'statusCode': 401,
        };
      }

      final body = {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'country': country,
        'gender': gender,
        'birthday': birthday,
        'birthPlace': birthPlace,
      };

      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/UpdateAccount'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return {
        'success': response.statusCode == 200,
        'data': jsonDecode(response.body),
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: $e',
        'statusCode': 500,
      };
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await TokenManager.isLoggedIn();
  }
}
