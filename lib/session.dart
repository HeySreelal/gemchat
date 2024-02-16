import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:televerse/televerse.dart';

class GenAISession extends Session {
  ChatSession? chat;

  GenAISession({this.chat});

  static GenAISession init(int id) {
    return GenAISession();
  }

  void setSession(ChatSession chat) {
    this.chat = chat;
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
