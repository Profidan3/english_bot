import 'package:english_bot/input_message.dart';
import 'package:english_bot/telegram_worker.dart';

Future<void> main() async {
  TelegramWorker worker = TelegramWorker();
  for (InputMessage inputMessage in await worker.getInputMessages()) {
    print(inputMessage.text);
  }
}
