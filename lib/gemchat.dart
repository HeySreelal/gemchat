import 'dart:io';
import 'package:gemchat/session.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:televerse/televerse.dart';

/// The Telegram Bot instance
/// Keep your token saved in your system environment variables
final bot = Bot<GenAISession>(Platform.environment["BOT_TOKEN"]!);

/// The GenerativeModel instance, which is used to interact with the AI model
///
/// Create a new environment variable called `GOOGLE_AI_TOKEN` and set it to your API key generated from the https://aistudio.google.com/app/
final gem = GenerativeModel(
  model: "gemini-pro",
  apiKey: Platform.environment["GOOGLE_AI_TOKEN"]!,
);

/// This method keeps track of the `/start` command and and greets the user.
///
/// It also initializes the session if it's not already initialized.
Future<void> starter(Context<GenAISession> ctx) async {
  await ctx.reply(
    "Hello, world! I'm Gem, your personal portal to Google's best AI model, Gemini. I can help you with a lot of things, like generating text, summarizing articles, and much more. Just send me a message and I'll do my best to help you out!",
  );
  _makeSureSessionIsInitialized(ctx);
}

/// This method is used to handle text messages sent by the user.
///
/// Whenever a user sends a text message, this method is called and it sends the message to the AI model to generate a response.
Future<void> textMessageHandler(Context<GenAISession> ctx) async {
  final prompt = ctx.message!.text!;
  final content = Content.text(prompt);
  try {
    ctx.replyWithChatAction(ChatAction.typing).then((_) {}).catchError((_) {});
    _makeSureSessionIsInitialized(ctx);
    final response = await ctx.session.chat!.sendMessage(content);
    final text = response.text ?? "I'm sorry, I couldn't understand that.";
    final chunks =
        text.length > 4096 ? text.split(RegExp(r"(.|[\r\n]){1,4096}")) : [text];
    await _sendContent(ctx, chunks);
  } catch (e) {
    await ctx.reply("I'm sorry, something went wrong. Here's the error: $e");
  }
}

/// Internal method to make sure the session is initialized before sending a message.
void _makeSureSessionIsInitialized(Context<GenAISession> ctx) {
  if (ctx.session.chat == null) {
    ctx.session.setSession(gem.startChat());
  }
}

/// Internal method to send the content in chunks of 4096 characters.
Future<void> _sendContent(
  Context<GenAISession> ctx,
  List<String> content,
) async {
  for (final chunk in content) {
    await ctx.reply(
      chunk,
      parseMode: ParseMode.markdown,
    );
  }
}
