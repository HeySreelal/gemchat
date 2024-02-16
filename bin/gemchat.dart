import 'package:gemchat/gemchat.dart';
import 'package:gemchat/session.dart';

void main(List<String> arguments) {
  bot.initSession(GenAISession.init);
  bot.start(starter);
  bot.onText(textMessageHandler);
}
