import 'cases_exports.dart';

Future<Map<String, String>> prepareOpenAIHeaders() async {
  final userDoc = await kDBUserRef().get();
  // if (!userDoc.exists) {
  //   showConfirmDialog(
  //       context,
  //       'No OpenAI Key specified',
  //       Text('please contact administrator to set you up with an OpenAI key'),
  //       () => {});
  //   return;
  // }
  final openai_key = userDoc.get('openai_key');

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${openai_key}',
  };
  return headers;
}
