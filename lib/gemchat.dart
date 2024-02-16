import 'dart:io';
import 'package:gemchat/session.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:televerse/televerse.dart';

final bot = Bot<GenAISession>(Platform.environment["BOT_TOKEN"]!);
final gem = GenerativeModel(
  model: "gemini-pro",
  apiKey: Platform.environment["GOOGLE_AI_TOKEN"]!,
);

Future<void> starter(Context<GenAISession> ctx) async {
  await ctx.reply(
    "Hello, world! I'm Gem, your personal portal to Google's best AI model, Gemini. I can help you with a lot of things, like generating text, summarizing articles, and much more. Just send me a message and I'll do my best to help you out!",
  );
  ctx.session.setSession(gem.startChat());
}

Future<void> textMessageHandler(Context<GenAISession> ctx) async {
  final prompt = ctx.message!.text!;
  final content = Content.text(prompt);
  try {
    ctx.replyWithChatAction(ChatAction.typing).then((_) {}).catchError((_) {});
    _makeSureSessionIsInitialized(ctx);
    final response = await ctx.session.chat!.sendMessage(content);
    final text = response.text ?? "I'm sorry, I couldn't understand that.";
    if (text.length > 4096) {
      final chunks = text.split(RegExp(r"(.|[\r\n]){1,4096}"));
      for (final chunk in chunks) {
        await ctx.reply(
          chunk,
          parseMode: ParseMode.markdown,
        );
      }
    } else {
      await ctx.reply(
        text,
        parseMode: ParseMode.markdown,
      );
    }
  } catch (e) {
    await ctx.reply("I'm sorry, something went wrong. Here's the error: $e");
  }
}

void _makeSureSessionIsInitialized(Context<GenAISession> ctx) {
  if (ctx.session.chat == null) {
    ctx.session.setSession(gem.startChat());
  }
}
