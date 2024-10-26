import 'dart:convert';

import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class PushNotificationService
{

  static Future<Map<String, dynamic>> _loadServiceAccount() async {
    final jsonString = await rootBundle.loadString('lib/Assets/fewsunsetsapart-47d253220c56.json');
    return json.decode(jsonString);
  }

  static Future<String> getAccessToken() async
  {

    final serviceAccountJson = await _loadServiceAccount();


    List<String> scopes =
    [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //get the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client
    );

    client.close();

    return credentials.accessToken.data;

  }

  static sendNotificationToSelectedPartner(String deviceToken, BuildContext context, String partnerID, String type) async
  {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging = "https://fcm.googleapis.com/v1/projects/fewsunsetsapart/messages:send";

    final Map<String, dynamic> message =
    {
      'message':
      {
        'token': deviceToken,
        'notification':
        {
          'title': "Love request from ${UserData.name}",
          'body': "Love request!"
        },
        'data':
        {
          'partnerID': partnerID,
          'type': type
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>
      {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    if(response.statusCode == 200)
    {
      print("Notification sent successfully");
    }
    else
    {
      print("Failed to send FCM message: ${response.statusCode}");
    }
  }
}