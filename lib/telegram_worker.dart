import 'dart:convert';

import 'package:english_bot/input_message.dart';
import 'package:english_bot/output_message.dart';
import 'package:http/http.dart' as http;

class TelegramWorker {
  // Запрашиваем сообщения пользователей от сервера Телеграм
  Future<List<InputMessage>> getInputMessages() async {
    try {
      String apiKey = String.fromEnvironment('TG_API_KEY');
      var response = await http
          .get(Uri.parse("https://api.telegram.org/bot$apiKey/getUpdates"));
      var bytes = response.bodyBytes;
      var text = utf8.decode(bytes);
      var map = jsonDecode(text) as Map;
      List result = map["result"] as List;

      List<InputMessage> inputMessages = [];
      for (Map item in result) {
        if (item.containsKey("message")) {
          InputMessage inputMessage = InputMessage(
            chatId: item['message']['chat']['id'],
            text: item['message']['text'],
          );
          inputMessages.add(inputMessage);
        }
      }
      return inputMessages;
    } catch (e) {
      print("ошибка запроса обновлений");
      return [];
    }
  }

  //отправляем сообшение от бота к пользователю
  Future<void> sendOutputMessage(OutputMessage outputMessage) async {
    try {
      Map<String, String> params = {
        "chat_id": outputMessage.chatId.toString(),
        "text": outputMessage.text,
        "reply_markup": jsonEncode({"inline_keyboard": outputMessage.buttons}),
      };
      String apiKey = String.fromEnvironment('TG_API_KEY');
      await http.post(
        Uri.parse(
            "https://api.telegram.org/bot$apiKey/sendMessage"),
        body: params,
      );
    } catch (e) {
      print("ошибка отправки сообшения");
      return;
    }
  }
}
