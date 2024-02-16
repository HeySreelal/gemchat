import 'package:gemchat/gemchat.dart';
import 'package:gemchat/session.dart';

void main(List<String> arguments) {
  // Initialize the session
  bot.initSession(GenAISession.init);

  // Start the bot and listen for /start commands
  bot.start(starter);

  // Listen for text messages
  bot.onText(textMessageHandler);
}
