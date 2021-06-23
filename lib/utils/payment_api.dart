import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PaymentApi {
  static const String paystackAPI = "https://api.paystack.co/transaction/";
  static const String verify =
      "https://api.paystack.co/transaction/verify/:reference";
  static const String skTest =
      "sk_test_79ff15aac709aeed992e2a13349a678ac492d68c";
  static const String callbackUrl = "https://rcffuta.org";

  static Map<String, String> headers(String skTest) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $skTest'
      };

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  static Future<bool> verifyPayment(String reference) async {
    http.Response response = await http.get(
      Uri.parse("https://api.paystack.co/transaction/verify/:$reference"),
      headers: headers(skTest),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map data = jsonDecode(response.body);
      if (data["message"] == "Verification successful") {
        print("Verification Successful");
        return true;
      } else {
        print("Verification not successful");
        print(data["message"]);
        return false;
      }
    }
    return false;
  }

  static Future<PaymentInit> initializePayment(int amount, String email) async {
    // LocalDriverDetails driverDetail = await _userStorage.retrieveLocalUser();

    try {
      Map initData = {
        "amount": amount,
        "email": email,
        "callback_url": callbackUrl,
        // "reference": _getReference()
      };

      String payload = json.encode(initData);

      http.Response response = await http.post(
          Uri.parse(paystackAPI + 'initialize'),
          headers: headers(skTest),
          body: payload);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map data = jsonDecode(response.body);

        String accessCode = data['data']['access_code'];
        String reference = data['data']['reference'];
        String authorizationUrl = data['data']['authorization_url'];

        print(authorizationUrl);

        return PaymentInit.fromJson(data);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class PaymentInit {
  String accessCode;
  String reference;
  String authorizationUrl;

  PaymentInit(this.accessCode, this.reference, this.authorizationUrl);

  PaymentInit.fromJson(Map json) {
    this.accessCode = json['data']['access_code'];
    this.reference = json['data']['reference'];
    this.authorizationUrl = json['data']["authorization_url"];
  }
}
