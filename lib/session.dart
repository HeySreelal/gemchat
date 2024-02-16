import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:televerse/televerse.dart';

/// The Session keeps track of the user's chat session with the AI model.
class GenAISession extends Session {
  ChatSession? chat;

  GenAISession({this.chat});

  GenAISession.init(int id);

  void setSession(ChatSession chat) {
    this.chat = chat;
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
