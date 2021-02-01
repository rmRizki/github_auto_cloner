import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:process_run/shell.dart';

Future<void> main(List<String> arguments) async {
  var baseUrl = 'https://api.github.com';

  print('🚀Github Auto Cloner🚀');
  print('Automatically download all repo from specified user');
  print('Input username: ');

  var userName = stdin.readLineSync();

  // maximum 100 repo
  var response = await http.get('$baseUrl/users/$userName/repos?per_page=100');

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    for (var i = 0; i < jsonResponse.length; i++) {
      var cloneUrl = jsonResponse[i]['clone_url'];
      var repoName = jsonResponse[i]['name'];
      print('found url ${i + 1}}: $cloneUrl');
      var shell = Shell();
      await shell.run('''
        git clone $cloneUrl output/$repoName
      ''');
    }
    print('done, check output directory for result');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
