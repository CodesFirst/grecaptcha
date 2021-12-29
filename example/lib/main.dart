import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grecaptcha/grecaptcha.dart';

void main() => runApp(const MyApp());

// Outside of this example app, you need to provide your own site key. You can
// generate them on https://www.google.com/recaptcha/admin#list by selecting
// reCAPTCHA Android. The readme of this plugin contains a more detailed
// explanation.
const String siteKey = "your_key";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

enum _VerificationStep {
  showingButton, working, error, verified
}

class _MyAppState extends State<MyApp> {

  // Start by showing the button inviting the user to use the example
  _VerificationStep _step = _VerificationStep.showingButton;

  void _startVerification() {
    setState(() => _step = _VerificationStep.working);

    Grecaptcha.verifyWithRecaptcha(siteKey).then((result) {
      /* When using reCaptcha in a production app, you would now send the $result
         to your backend server, so that it can verify it as well. In most
         cases, an ideal way to do this is sending it together with some form
         fields, for instance when creating a new account. Your backend server
         would then take the result field and make a request to the reCaptcha
         API to verify that the user of the device where the registration
         request is from is a human. It could then continue processing the
         request and complete the registration. */
      setState(() => _step = _VerificationStep.verified);
    }, onError: (e, s) {
      if (kDebugMode) {
        print("Could not verify:\n$e at $s");
      }
      setState(() => _step = _VerificationStep.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_step) {
      case _VerificationStep.showingButton:
        content = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("This example will use the reCaptcha API to verify that you're human"),
              MaterialButton(
                onPressed: _startVerification,
                child: const Text("VERIFY"),
                color: Colors.blueAccent,
                textColor: Colors.white,
              )
            ]
        );
        break;
      case _VerificationStep.working:
        content = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text("Trying to figure out whether you're human"),
            ]
        );
        break;
      case _VerificationStep.verified:
        content = const Text(
            "The reCaptcha API returned a token, indicating that you're a human. "
                "In real world use case, you would send use the token returned to "
                "your backend-server so that it can verify it as well."
        );
        break;
      case _VerificationStep.error:
        content = const Text(
            "We could not verify that you're a human :( This can occur if you "
                "have no internet connection (or if you really are a a bot)."
        );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('reCaptcha example'),
        ),
        body: Center(
          child: content,
        ),
      ),
    );
  }
}
