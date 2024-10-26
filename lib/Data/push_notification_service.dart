import 'dart:convert';

import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class PushNotificationService
{

  static Future<String> getAccessToken() async
  {
    final serviceAccountJson =
    {
      "type": "service_account",
      "project_id": "fewsunsetsapart",
      "private_key_id": "f071bfc8a37097e5e7b5078ba162979e09c012ed",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCsg2TujGqCHyME\nF41CTugiNY6hWDKj20eqlM/dJPSXT11p2a9jZFg1AjCzDSUeIk0a2F/HBgvFl/vn\noy4PqORX3zol6E1q2/XpUzf7+EFpkY9Nkdq2hYP+s5+Ik0hTprb90ATfl2baywdL\n9Z3YKFyIK5+WiS+vc8zxtsWukLp6W9HrDCzA6QrnuMNFzfKu0EzT6CJLXw4M54yZ\nr3JASmjhww8ij8AJwRE5Sx7bjZ7CdCRF+BIZZKTclBkv/zlIcGyeEevbVqVGRVwG\nQpzmGTGE3iQB66u/169LTUcJfFddynVOMcVtJkSlTI69/10ai5j7GcyqVSL8rpxQ\nmItYfnZnAgMBAAECggEAUzZd7SMWDQXv4f1qSd294yJqVjEw3BDdlM6LJWS6BnJl\n4LT8ALlaQtd3niZtDQgGoThVmq6z5u/UtnrjsPIKksg+SCKxlSXcjFtz2bp58u4f\nbY85LGlirez+uuYwMQltoyg/8YoaNtdQAbfMF4QAfj5skDREKCF3bfB3kiiFipcL\nstviuLoFdNrTFvwwpPCoeViQGwUxQwbWZGoEyoKeWpo+F7duTQLfpYwOd9or628V\nztrJdv4G2ANyFf49sYp2y2A7h5tcEvvNvY2po25y8a27TpdQdrPjA2i6fEj8FiBB\nD2CLEEihz728wSND198Gzlr6cSndGHu/ceTXT1/QAQKBgQDrbFb0FRZhI8YS71a8\nbvkdPB3SDbTrzQkIHZxYdNuuW3xHlBcxdkCF0ukEHrY00KRdo/7csjX2LCs8m8OG\nhQnp3c2cj7kNh72JW8MLQsSfKY6+Neych8UOyrq2ci4qOHt8w8RqM4X+63uQSgG5\nzT1kqIByLfTip+lO4vP7/0/oZwKBgQC7l21L8J5+PRg7g8n6eb+PZP1zKeT9OQiV\nj8xo9VI3SqL2tFutvAQWEefBwWdWNFJwMW+qle3hydHDyXOs7zG1ND2lTKlBuPXC\nEead5/ABXZrEgrwtEZ6loEE2E9PTbMvqlRqStQuCAXkLKQBZ15luW/p+LngKq3Jo\n8ueBjBxCAQKBgQC3Iocdxo2rMS3zKtXZLaaCFHLKJTl5OP1un8IwmW8O2kH6WHwW\nUPvuXlw/hTiOK0PBSEKJIeSSRFe6BR17tmA42f8JbFAy80YA5S37w4u6mJRe6QnP\n1ln3oMLQDFBXLar6KjvPtZbl7/8mBjwDcmHwvJd2usNF0gLPCANuI3TgvwKBgBni\nbCdlXUlH/tb/eVhBgmgz5DEG39z9CK0yeV8mMqEEgHYQLvJLFjlBYTxABpVDhPiM\nKb9dDsTwByy/2GFNZAt/2N29NUGnVunfdHXnchuOIfPpojOJ0d1CvpzKoZjz0zNc\nPZ1us9bNgzlCABVlhXtP38GXgeLfA1tt4PnkLmYBAoGAT3b9uDEPYDRhIg9rjQoH\n6Z1ira2pxRbVrHj5argoeHySj6LNAqWnj4IIuAvmZt0YuVu5DKfPU/kdSYb3T82Y\nSohfRR/+CiBEeh4M1FmfQflEhcLBTaAF50XtZxI5AuoAmE/zAINEK4lzUospO68c\nbzEjDP6j2uxdNPR6J/gCt3M=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-2sjfx@fewsunsetsapart.iam.gserviceaccount.com",
      "client_id": "107275373844197439527",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-2sjfx%40fewsunsetsapart.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

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