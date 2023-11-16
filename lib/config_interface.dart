import 'dart:convert';
import 'dart:io';

import 'package:chatgpt_cli/app_settings.dart';

class ConfigInterface {
  late Directory appDir;
  AppSettings appSettings = AppSettings.defaults();

  ConfigInterface() {
    _setAppDir();
    _loadJsonConfig();
  }

  void _loadJsonConfig() {
    final File data = File("${appDir.path}\\config.json");

    //check if config file exists
    if (!data.existsSync()) {
      print("No existing config file found");
      print("Creating new config file...");
      data.createSync();
      data.writeAsStringSync("{}");
    }
    AppSettings settings = AppSettings.defaults();

    try {
      settings = AppSettings.fromJson(jsonDecode(data.readAsStringSync()));
    } catch (e) {
      print(
          "Error loading config file. Try deleting ${appDir.path}\\config.json and retry.");
    }

    appSettings = settings;
  }

  void saveApiKey(String key) {
    //strip quotation marks from string
    if (key.startsWith("\"") && key.endsWith("\"")) {
      key = key.substring(1, key.length - 1);
    }

    final Map<String, dynamic> json =
        jsonDecode(File("${appDir.path}\\config.json").readAsStringSync());
    json['apiKey'] = key;
    File("${appDir.path}/config.json").writeAsStringSync(jsonEncode(json));
  }

  void _setAppDir() {
    if (Platform.isWindows) {
      final Directory appDataDir = Directory(Platform.environment['APPDATA']!);
      //check if a directory for the ChatGPT-CLI already exists
      appDir = Directory("${appDataDir.path}\\ChatGPT-CLI");

      if (!appDir.existsSync()) {
        appDir.createSync();
      }
    }

    if (Platform.isLinux || Platform.isMacOS) {
      final Directory appDataDir = Directory(Platform.environment['HOME']!);

      //check if .config/ChatGPT-CLI exists

      appDir = Directory("${appDataDir.path}/.config/ChatGPT-CLI");

      if (!appDir.existsSync()) {
        appDir.createSync(recursive: true);
      }
    }
  }
}
