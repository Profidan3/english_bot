import 'dart:convert';

import 'package:english_bot/input_message.dart';
import 'package:english_bot/output_message.dart';
import 'package:http/http.dart' as http;

class TelegramWorker {
  final String _apiKey;

  TelegramWorker(this._apiKey);

  // Запрашиваем сообщения пользователей от сервера Телеграм
  Future<List<InputMessage>> getInputMessages() async {
    try {
      var response = await http
          .get(Uri.parse("https://api.telegram.org/bot$_apiKey/getUpdates"));
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
   // try {
      Map<String, String> params = {
        "chat_id": outputMessage.chatId.toString(),
        "text": outputMessage.text,
        "reply_markup": jsonEncode({"inline_keyboard": outputMessage.buttons}),
      };
      await http.post(
        Uri.parse("https://api.telegram.org/bot$_apiKey/sendMessage"),
        body: params,
      );
   /* } catch (e) {
      print("ошибка отправки сообшения");
      return;
    }*/
  }
}
