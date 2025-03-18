import 'package:english_bot/button.dart';
import 'package:english_bot/input_message.dart';
import 'package:english_bot/output_message.dart';
import 'package:english_bot/telegram_worker.dart';

Future<void> main() async {
  String apiKey = String.fromEnvironment('TG_API_KEY');
  TelegramWorker worker = TelegramWorker(apiKey);
  for (InputMessage inputMessage in await worker.getInputMessages()) {
    print(inputMessage.text);
    OutputMessage outputMessage = OutputMessage(
      chatId: inputMessage.chatId,
      text: inputMessage.text,
      buttons: [
        [
          Button(text: "1", callbackData: "100"),
          Button(text: "2", callbackData: "200")
        ]
      ],
    );
    worker.sendOutputMessage(outputMessage);
  }
}
