import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_ui_starter/models/access.dart';
import 'package:flutter_chat_ui_starter/models/conversationManager.dart';
import 'package:flutter_chat_ui_starter/screens/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: camel_case_types
class API_Manager {
  static String access_token;
  static List<String> bot_process;
  static List<String> bot_reply = List(10);
  Future<NewModel> getNews() async {
    final response = await http.post(
      Uri.parse('http://192.168.50.221:5002/api/auth'),
      body: '{"username": "me", "password": "password"}',
    );

    //return NewModel.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return NewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Access denied');
    }
  }

  /*addTokenToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }*/

  static Future<ConversationManager> conversation(String chat) async {
    /*if (access_token == null) {
      return null;
    }*/
    final response = await http.post(
      Uri.parse('http://192.168.50.221:5002/api/conversations/9/messages/'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $access_token',
      },
      body: '{"message":"$chat"}',
    );

    //return ConversationManager.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {

      List result = jsonDecode(response.body);
       for(int i=0 ; i< result.length; i++){
        bot_reply[i]= result[i].toString().substring(23,result[i].toString().length -1);

        }


      //return null;

      return null;
    } else {
      return null;
      //throw Exception('fuck');
    }
  }
}

