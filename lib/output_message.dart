import 'package:english_bot/button.dart';

class OutputMessage {
  OutputMessage({
    required this.chatId,
    required this.text,
    this.buttons = const [],
  });

  int chatId;
  String text;
  List<List<Button>> buttons;
}
