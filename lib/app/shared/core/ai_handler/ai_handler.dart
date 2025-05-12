import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiktoken/tiktoken.dart';
import 'package:toastification/toastification.dart';

List<Map<String, dynamic>> extractJSONFromString(String input) {
  List<Map<String, dynamic>> jsonObjects = [];

  // Regular expression to match JSON objects
  final RegExp jsonRegex = RegExp(r'({(?:[^{}"]|"[^"]*"|{[^{}]*})*})');

  final Iterable<Match> matches = jsonRegex.allMatches(input);

  for (final Match match in matches) {
    try {
      final String jsonString = match.group(0) ?? '';
      final Map<String, dynamic> jsonObject = jsonDecode(jsonString);
      jsonObjects.add(jsonObject);
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }

  return jsonObjects;
}

String extractSingleJSONFromString(String input) {
  return input
      .substring(6)
      .replaceAll('[DONE]', '')
      .split("""

data: """)
      .where((element) => element.trim().isNotEmpty)
      .map((e) =>
          Map<String, dynamic>.from(jsonDecode(e))['choices'][0]['delta']
              ['content'] ??
          "")
      .join("");
}

class AiHandler {
  final String systemPrompt;

  AiHandler(this.systemPrompt);

  http.Client client = http.Client();
  http.Request request = http.Request(
      'POST',
      Uri.parse(
        '${const String.fromEnvironment('supabase_url')}/functions/v1/ai_query',
      ))
    ..headers['Content-Type'] = 'application/json'
    ..headers['Authorization'] =
        'Bearer ${Supabase.instance.client.auth.currentSession!.accessToken}';

  late Stream<String> stream;

  // Method to get chat response as a stream
  Stream<String> getChatResponseStream(context, String query,
      {AiMode mode = AiMode.chat, String? userId}) async* {
    final body = jsonEncode({
      'prompt': systemPrompt,
      'query': query,
      'name': AppLocalStorage.user?.name,
      'mode': mode.name,
      'user_id': userId ?? AppLocalStorage.hushhId!,
      'agent_chat': userId != null
    });

    try {
      final streamedResponse = await client.send(request..body = body);

      await for (var event in streamedResponse.stream.transform(utf8.decoder)) {
        yield event;
      }
    } catch (e) {
      ToastManager(Toast(
              title: "Some error occurred while connecting with HushhAI!",
              type: ToastificationType.error))
          .show(context);

      //  final user = sl<CardWalletPageBloc>().user!;
      //       if (user.lastUsedTokenDateTime!
      //           .add(const Duration(days: 30))
      //           .isAfter(user.getLastTokenMonth())) {
      //         ToastManager(Toast(
      //             title: "Service reactivated",
      //             type: ToastificationType.success))
      //             .show(context);
      //         sl<CardWalletPageBloc>().add(ResetTokenUsageEvent());
      //         _handleSendPressed(text, message: message);
      //         return;
      //       } else {
      //         ToastManager(Toast(
      //             title:
      //             "High usage detected, service will be reactivated on ${DateFormat('dd MMM, yyyy').format(user.getLastTokenMonth())}",
      //             type: ToastificationType.error))
      //             .show(context);
      //         return;
      //       }
    }
  }

  // Method to get chat response as a single future result
  Future<String?> getChatResponse(String query,
      {AiMode mode = AiMode.single}) async {
    final StringBuffer buffer = StringBuffer();

    final body = jsonEncode({
      'prompt': systemPrompt,
      'query': query,
      'name': AppLocalStorage.user?.name,
      'mode': mode.name,
    });

    try {
      final streamedResponse = await client.send(request..body = body);

      await for (var event in streamedResponse.stream.transform(utf8.decoder)) {
        buffer.write(event);
      }
      return buffer.toString();
    } catch (e) {
      print('Error sending request: $e');
      return null;
    }
  }
}

class AiSummaryHandler {

  AiSummaryHandler();

  http.Client client = http.Client();
  http.Request request = http.Request(
      'POST',
      Uri.parse(
        '${const String.fromEnvironment('supabase_url')}/functions/v1/ai_summary',
      ))
    ..headers['Content-Type'] = 'application/json'
    ..headers['Authorization'] =
        'Bearer ${Supabase.instance.client.auth.currentSession!.accessToken}';

  late Stream<String> stream;

  // Method to get chat response as a stream
  Stream<String> getChatResponseStream(context, int cardId, String name, String brandName, String userId) async* {
    final body = jsonEncode({
      "card_id": cardId,
      "user_name": name,
      "brand_name": brandName,
      "user_id": userId
    });

    try {
      final streamedResponse = await client.send(request..body = body);

      await for (var event in streamedResponse.stream.transform(utf8.decoder)) {
        yield event;
      }
    } catch (e) {
      ToastManager(Toast(
          title: "Some error occurred while connecting with HushhAI!",
          type: ToastificationType.error))
          .show(context);
    }
  }
}

int numTokensFromMessages(List<Map<String, dynamic>> messages,
    {String model = "gpt-3.5-turbo"}) {
  Tiktoken encoding;
  int tokensPerMessage;
  int tokensPerName;
  try {
    encoding = encodingForModel(model);
  } catch (_) {
    encoding = getEncoding("cl100k_base");
  }
  if (model == "gpt-3.5-turbo-0613" ||
      model == "gpt-3.5-turbo-16k-0613" ||
      model == "gpt-4-0314" ||
      model == "gpt-4-32k-0314" ||
      model == "gpt-4-0613" ||
      model == "gpt-4-32k-0613") {
    tokensPerMessage = 3;
    tokensPerName = 1;
  } else if (model == "gpt-3.5-turbo-0301") {
    tokensPerMessage = 4; // every message follows {role/name}\n{content}\n
    tokensPerName = -1; // if there's a name, the role is omitted
  } else if (model.contains("gpt-3.5-turbo")) {
    print(
        "Warning: gpt-3.5-turbo may update over time. Returning num tokens assuming gpt-3.5-turbo-0613.");
    return numTokensFromMessages(messages, model: "gpt-3.5-turbo-0613");
  } else if (model.contains("gpt-4")) {
    print(
        "Warning: gpt-4 may update over time. Returning num tokens assuming gpt-4-0613.");
    return numTokensFromMessages(messages, model: "gpt-4-0613");
  } else {
    throw UnimplementedError(
        "numTokensFromMessages() is not implemented for model $model. See https://github.com/openai/openai-python/blob/main/chatml.md for information on how messages are converted to tokens.");
  }

  var numTokens = 0;
  for (var message in messages) {
    numTokens += tokensPerMessage;
    message.forEach((key, value) {
      numTokens += encoding.encode(value).length;
      if (key == "name") {
        numTokens += tokensPerName;
      }
    });
  }
  numTokens += 3; // every reply is primed with assistant
  return numTokens;
}

// Future<int> numTokensFromPrompt(String prompt,
//     {String model = "gpt-3.5-turbo-0613"}) async {
//   final count = await Tokenizer().count(
//     prompt,
//     modelName: model,
//   );
//   return count;
// }
