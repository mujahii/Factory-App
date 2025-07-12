import 'dart:convert';
import 'package:http/http.dart' as http;

class MongoAPI {
  final String apiKey =
      'FX6AwlRbq08KfHcLeWZJEIkvOah8F6svDANKUZSBdSXl8SEJHRGsQcUWwimbReKJ';
  apiTemplate(function) {
    String endpoint = function + "End";
    return "https://ap-southeast-1.aws.data.mongodb-api.com/app/data-fcrklnw/endpoint/$endpoint";
  }

  Future<Map<String, dynamic>> otpGen(String phoneNumber) async {
    final response = await http.post(
      Uri.parse(apiTemplate("otpGen")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({'phoneNumber': "+60" + phoneNumber}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate OTP: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> otpVerify(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse(apiTemplate("otpVerify")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({'phoneNumber': "+60" + phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('bearerToken')) {
        return responseData;
      } else {
        throw Exception('Bearer token not found in the response.');
      }
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> bearerLogout(String bearerToken) async {
    final response = await http.post(
      Uri.parse(apiTemplate("bearerLogout")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({'bearerToken': bearerToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to logout: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> factoryGet(String bearerToken) async {
    final response = await http.post(
      Uri.parse(apiTemplate("factoryGet")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({'bearerToken': bearerToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch factory names: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> factoryParamGet(
      String factoryName, String bearerToken) async {
    final response = await http.post(
      Uri.parse(apiTemplate("factoryParamGet")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body:
          jsonEncode({'factoryName': factoryName, 'bearerToken': bearerToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch factory parameters: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> factoryParamDayGet(
      String bearerToken, String factoryName, String date) async {
    final response = await http.post(
      Uri.parse(apiTemplate("factoryParamDayGet")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'bearerToken': bearerToken,
        'factoryName': factoryName,
        'date': date
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get items by date: ${response.body}');
    }
  }

  //The returned body contains <success>, <message>
  Future<Map<String, dynamic>> factoryAddUser(String bearerToken, String name,
      String factoryName, String phoneNumber) async {
    final response = await http.post(
      Uri.parse(apiTemplate("factoryAddUser")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'bearerToken': bearerToken,
        'name': name,
        'factoryName': factoryName,
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add engineer: ${response.body}');
    }
  }

//Returns body with sucess and message
  Future<Map<String, dynamic>> userNotificationUpdate(
      String bearerToken, String factoryName, List<dynamic> values) async {
    final response = await http.post(
      Uri.parse(apiTemplate("userNotificationUpdate")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'bearerToken': bearerToken,
        'factoryName': factoryName,
        'values': values
      }),
    );
    //Body sends success and message
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update notification: ${response.body}');
    }
  }

//Returns body with sucess and notifications
  Future<Map<String, dynamic>> userNotificationGet(
      String bearerToken, String factoryName) async {
    final response = await http.post(
      Uri.parse(apiTemplate("userNotificationGet")),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'bearerToken': bearerToken,
        'factoryName': factoryName,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve notifications: ${response.body}');
    }
  }

  //Returns body with sucess and users
  Future<Map<String, dynamic>> factoryUserGet(
      String bearerToken, String factoryName) async {
    try {
      final response = await http.post(
        Uri.parse(apiTemplate("factoryUserGet")),
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey,
        },
        body: jsonEncode({
          'bearerToken': bearerToken,
          'factoryName': factoryName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to retrieve users: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      throw Exception('Error: $e');
    }
  }
}
