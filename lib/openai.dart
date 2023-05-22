
// import 'package:flutter/material.dart';

// class CompletionsApi {

//   static final Uri completionsEndpoint = Uri.parse('https://api.openai.com/v1/completions');

//   /// Gets a "weather forecast" from the OpenAI completions endpoint
//   // static Future<CompletionsResponse> getNewForecast() async {
//   //   debugPrint('Getting a new weather forecast');

//   //   CompletionsRequest request = CompletionsRequest(
//   //     model: 'text-curie-001',
//   //     prompt: 'Today's forecast is',
//   //     maxTokens: 9,
//   //     temperature: 0.6,
//   //   );
//   //   debugPrint('Sending OpenAI API request with prompt, "${completionsPrompts[promptIndex]}", and temperature, $temp.');
//   //   http.Response response = await http.post(completionsEndpoint,
//   //       headers: headers, body: request.toJson());
//   //   debugPrint('Received OpenAI API response: ${response.body}');
//   //   // Check to see if there was an error
//   //   if (response.statusCode != 200) {
//   //     // TODO handle errors
//   //     debugPrint('Failed to get a forecast with status code, ${response.statusCode}');
//   //   }
//   //   CompletionsResponse completionsResponse = CompletionsResponse.fromResponse(response);
//   //   return completionsResponse;
//   // }


// }

// /// Represents the parameters used in the body of a request to the OpenAI completions endpoint.
// class CompletionsRequest {
//   final String model;
//   final String prompt;
//   final int maxTokens;
//   final double? temperature;
//   final int? topP;
//   final int? n;
//   final bool? stream;
//   final int? longprobs;
//   final String? stop;

//   CompletionsRequest({
//     required this.model,
//     required this.prompt,
//     required this.maxTokens,
//     required this.temperature,
//     this.topP,
//     this.n,
//     this.stream,
//     this.longprobs,
//     this.stop,
//   });
// }

// /// Returns a [CompletionResponse] from the JSON obtained from the
// /// completions endpoint.
// factory CompletionsResponse.fromResponse(Response response) {
//   // Get the response body in JSON format
//   Map<String, dynamic> responseBody = json.decode(response.body);

//   // Parse out information from the response
//   Map<String, dynamic> usage = responseBody['usage'];

//   // Parse out the choices
//   List<dynamic> choices = responseBody['choices'];

//   // Get the text of the first completion
//   String firstCompletion = choices[0]['text'];

//   return CompletionsResponse(
//     id: responseBody['userId'],
//     object: responseBody['id'],
//     created: responseBody['title'],
//     model: responseBody['model'],
//     choices: choices,
//     usage: usage,
//     promptTokens: usage['prompt_tokens'],
//     completionTokens: usage['completion_tokens'],
//     totalTokens: usage['total_tokens'],
//     firstCompletion: firstCompletion,
//   );
// }

  