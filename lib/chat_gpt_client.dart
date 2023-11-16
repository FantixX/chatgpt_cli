import 'dart:async';
import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt_cli/config_interface.dart';
import 'package:chatgpt_cli/util.dart';

class ChatGPTClient {
  List conversationHistory = [];

  final config = ConfigInterface();

  late OpenAI client;

  ChatGPTClient() {
    client = OpenAI.instance.build(
        token: config.appSettings.apiKey,
        baseOption: HttpSetup(receiveTimeout: Duration(seconds: 5)),
        enableLog: true);
  }

  Future<void> chatRequest(String input) async {
    Completer<void> completer = Completer<void>();
    String fullResponse = "";
    final request = ChatCompleteText(
        model: GptTurbo0631Model(),
        messages: [
          ...conversationHistory,
          Messages(role: Role.user, content: input)
        ],
        stream: true);
    client.onChatCompletionSSE(request: request).listen((event) {
      _printAnswerString(event.choices!.last.message!.content,
          prefix: fullResponse.isEmpty);
      fullResponse += event.choices!.last.message!.content;
    }).onDone(() {
      conversationHistory
          .add(Messages(role: Role.assistant, content: fullResponse));
      blank();
      completer.complete();
    });
    return await completer.future;
  }

  void _printAnswerString(String string, {bool prefix = false}) {
    if (prefix) {
      stdout.write("${chalk.cyan.bold("ChatGPT")}: ${chalk.cyan(string)}");
    } else {
      stdout.write(chalk.cyan(string));
    }
  }
}
