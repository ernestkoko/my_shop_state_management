import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../model/form.dart';

// FormController is a class which does work of saving FeedbackForm in Google Sheets using
// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
enum ErrorException { noException, onException }

class FormController {
  //Google App Script web url
  static const String URL =
      'https://script.google.com/macros/s/AKfycbz8ifksndE1HBQKphkdkEtxOvtu3kJMED_J0GSMfuDRdINIab0/exec';

  //success status message
  static const String STATUS_SUCCESS = 'SUCCESS';
  ErrorException _errorException = ErrorException.onException;

  ErrorException get getError => _errorException;

// Async function which saves feedback, parses [feedbackForm] parameters
// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  Future<void> submitForm(
      FeedbackForm feedbackForm, Future<void> Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then(
        (response) async {
          print("response1: ${response.statusCode}");

          if (response.statusCode == 302) {
           _errorException= ErrorException.noException;
            print("message: " + response.reasonPhrase);
            var url = response.headers['location'];
            await http.get(url).then((response)async {
              await callback(convert.jsonDecode(response.body)['status']);

            });
          } else {
            _errorException=ErrorException.noException;
            callback(convert.jsonDecode(response.body)['status']);
          }
        },
      );
    } catch (e) {
      print("error: $e");
      _errorException =ErrorException.onException;
      rethrow;
    }
  }
}
