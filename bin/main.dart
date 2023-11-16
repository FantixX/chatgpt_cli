import 'dart:io';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt_cli/chat_gpt_client.dart';
import 'package:chatgpt_cli/chatgpt_cli.dart' as chatgpt_cli;
import 'package:chatgpt_cli/config_interface.dart';
import 'package:chatgpt_cli/util.dart';

void main(List<String> arguments) async {
  if (Platform.isWindows) {
    final Directory appDataDir = Directory(Platform.environment['APPDATA']!);
    print(appDataDir.absolute);
  }

  if (Platform.isLinux || Platform.isMacOS) {
    final Directory appDataDir = Directory(Platform.environment['HOME']!);
    print(appDataDir.absolute);
  }

  final config = ConfigInterface();

  if (config.appSettings.apiKey == null) {
    print("No API Key saved. Please enter your API Key:");
    final key = stdin.readLineSync();

    //check if valid string
    switch (key) {
      case (null):
        print("No API Key entered. Exiting...");
        return;
      case (""):
        print("Empty API Key provided");
        return;
    }

    config.saveApiKey(key);
  }

  final client = ChatGPTClient();

  while (true) {
    print("Enter prompt:");
    final prompt = stdin.readLineSync();
    blank();
    if (prompt == null) return;
    if (prompt == ".exit") break;
    await client.chatRequest(prompt);
  }

  for (Messages message in client.conversationHistory) {
    print(message.content);
  }
}
