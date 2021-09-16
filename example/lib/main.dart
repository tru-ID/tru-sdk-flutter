/*
 * MIT License
 * Copyright (C) 2020 4Auth Limited. All rights reserved
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';

import 'src/http/mock_client.dart';

// Set up a local tunnel base url.
final String baseURL = "<YOUR_LOCAL_TUNNEL_URL>";

void main() {
  runApp(PhoneCheckApp());
}

class PhoneCheckApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tru.ID Phone Check Sample',
      theme: ThemeData(),
      home: PhoneCheckHome(title: 'tru.ID Flutter Sample App'),
    );
  }

}

class PhoneCheckHome extends StatefulWidget {
  PhoneCheckHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PhoneCheckAppState createState() => _PhoneCheckAppState();
}

class _PhoneCheckAppState extends State<PhoneCheckHome> {
  Future<CheckStatus>? _futurePhoneCheck;
  String? _result = null;
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tru.ID Sample App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('tru.ID Flutter Sample App'),
        ),
        body: bodyContainer(),
      ),
    );
  }

  Container bodyContainer() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: (_futurePhoneCheck == null) ? bodyForm() : buildFutureBuilder(),
    );
  }

  Form bodyForm() {
    return Form(
      key: _formKey,
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              logo(),
              const SizedBox(height: 24),
              validatingTextField(),
              const SizedBox(height: 24),
              validatingFormField(),
              const SizedBox(height: 24),
              verifyButton(),
              Text((_result == null) ? "" : "Results ${_result}" )
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<CheckStatus> buildFutureBuilder() {
    return FutureBuilder<CheckStatus>(
      future: _futurePhoneCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            _result = 'Match status: ${snapshot.data!.match}';
          } else if (snapshot.hasError) {
            _result = '$snapshot.error';
          }
          return bodyForm();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          print("-->");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget logo() {
    return  Center(
      child: Image.asset('assets/images/1024.png',
          width: 175.0,
          height: 100.0,
          fit: BoxFit.cover),
    );
  }

  // A text field that validates that the text is a phone number.
  TextFormField validatingTextField() {
    return TextFormField(
      //autofocus: true,
      initialValue: (phoneNumber == null) ? null : phoneNumber,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a phone number.';
        }
        RegExp exp = RegExp(r"^(?:[+0][1-9])?[0-9]{10,12}$");
        if (exp.hasMatch(value)) {
          return null;
        }
        return 'Not a valid phone number';
      },
      decoration: const InputDecoration(
        filled: true,
        hintText: 'e.g. +447830305594',
        labelText: 'Enter phone number',
      ),
      onChanged: (value) {
        phoneNumber = value;
      },
    );
  }

  // A custom form field that requires the user to check a checkbox.
  FormField<bool> validatingFormField() {
    return FormField<bool>(
      initialValue: agreedToTerms,
      validator: (value) {
        if (value == false) {
          return 'You must agree to the terms of service.';
        }
        return null;
      },
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (value) {
                    // When the value of the checkbox changes,
                    // update the FormFieldState so the form is
                    // re-validated.
                    formFieldState.didChange(value);
                    setState(() {
                      agreedToTerms = value!;
                    });
                  },
                ),
                Text(
                  'I agree to the terms of service.',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            if (!formFieldState.isValid)
              Text(
                formFieldState.errorText ?? "",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).errorColor),
              ),
          ],
        );
      },
    );
  }

  Widget verifyButton() {
    return TextButton(
      child: const Text('Verify'),
      onPressed: () {
        // Validate the form by getting the FormState from the GlobalKey
        // and calling validate() on it.
        var valid = _formKey.currentState!.validate();
        if (!valid) {
          return;
        }
        if(phoneNumber != null) {
          FocusScope.of(context).unfocus();
          setState(() {
            _futurePhoneCheck = executeFlow(phoneNumber!);
          });
        }
      },
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<CheckStatus> executeFlow(String phoneNumber) async {
    print("[PhoneCheck] - Creating phone check");
    final response = await http.post(
      Uri.parse('$baseURL/phone-check'),
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': phoneNumber,
      }),
    );

    print("[PhoneCheck] - Received response");
    if (response.statusCode == 200) {
      PhoneCheck checkDetails = PhoneCheck.fromJson(jsonDecode(response.body));
      // Platform messages may fail, so we use a try/catch PlatformException.
      // We also handle the message potentially returning null.
      try {
        // String platformVersion = await Trusdkflutter.platformVersion ?? 'Unknown platform version';

        TruSdkFlutter sdk = TruSdkFlutter();
        //await performPhoneCheck(checkDetails.url);//This over Flutter http, testing purposes.
        String? result = await sdk.check(checkDetails.url);
        print("Check Results -> ${result}");
        //Alternatively, we can use checkWithTrace
        //await sdk.checkWithTrace(checkDetails.url);
        //await sdk.isReachable();

      } on PlatformException {
        throw Exception('Failed execute platform request');
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      // if (!mounted) {
      //   return;
      // }

      return fetchPhoneCheckResult(checkDetails.id);

    } else {
      throw Exception('Failed to create phone check');
    }
  }

}


Future<CheckStatus> fetchPhoneCheckResult(String checkID) async {
  print("[CheckStatus] - Fetching phone check status");
  final response = await http.get(
    Uri.parse('$baseURL/phone-check?check_id=${checkID}'),
  );

  print("[CheckStatus] - Received response");
  if (response.statusCode == 200) {
    print('Response: ${response.body}');
    return CheckStatus.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetching phone check status');
  }
}

class PhoneCheck {
  final String id;
  final String url;

  PhoneCheck({required this.id, required this.url});

  factory PhoneCheck.fromJson(Map<String, dynamic> json) {
    return PhoneCheck(
      id: json['check_id'],
      url: json['check_url'],
    );
  }
}

class CheckStatus {
  final String id;
  bool match = false;

  CheckStatus({required this.id, required this.match});

  factory CheckStatus.fromJson(Map<String, dynamic> json) {
    return CheckStatus(
      id: json['check_id'],
      match: json['match'] == null ? false : json['match'],
    );
  }
}

// Set up a mock HTTP client.
final http.Client httpClient = MockClient();

Future<String> getMockData() {
  return Future.delayed(Duration(seconds: 2), () {
    return "PhoneCheck Mock data";
    // throw Exception("Custom Error");
  });
}

Future<String> asyncMockData() async{
  await Future.delayed(Duration(seconds: 10));
  return Future.value("PhoneCheck Mock data");
}
