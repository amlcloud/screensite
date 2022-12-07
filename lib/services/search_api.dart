import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class ApiService {
  String endpoint = 'https://reqres.in/api/users?page=2';

  Future<List<Object>> getUser() async {
    Response response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => e as Object)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

//API SERVICE Provider
final apiProvider = Provider<ApiService>((ref) => ApiService());
