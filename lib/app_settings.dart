import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AppSettings {
  final String? apiKey;
  final ChatModel? gptModel;

  AppSettings({required this.apiKey, required this.gptModel});
  AppSettings.defaults()
      : apiKey = null,
        gptModel = GptTurboChatModel();

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
        apiKey: json['apiKey'] as String?,
        gptModel: ChatModelFromValue(
            model: json['gptModel'] as String? ?? "gpt-3.5-turbo"));
  }
}
