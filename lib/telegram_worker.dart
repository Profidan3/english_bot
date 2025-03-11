import 'dart:convert';

import 'package:english_bot/input_message.dart';
import 'package:http/http.dart' as http;

class TelegramWorker {
  // Запрашиваем сообщения пользователей от сервера Телеграм
  Future<List<InputMessage>> getInputMessages() async {
    try {
      String apiKey = String.fromEnvironment('TG_API_KEY');
      var response = await http.get(Uri.parse(
          "https://api.telegram.org/bot$apiKey/getUpdates"));
      var bytes = response.bodyBytes;
      var text = utf8.decode(bytes);
      var map = jsonDecode(text) as Map;
      List result = map["result"] as List;

      List<InputMessage> inputMessages = [];
      for (Map item in result) {
        InputMessage inputMessage = InputMessage(
          chatId: item['message']['chat']['id'],
          text: item['message']['text'],
        );
        inputMessages.add(inputMessage);
      }
      return inputMessages;
    } catch (e) {
      print("ошибка запроса обновлений");
      return [];
    }
  }
}
