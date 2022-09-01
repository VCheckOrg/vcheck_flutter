import 'package:flutter/material.dart';
import 'dart:async';

import 'package:vcheck_flutter/vcheck_flutter.dart';
import 'package:vcheck_flutter_example/result_widget.dart';

//For test env only:
const String VERIFICATION_TOKEN = 'to-get-from-service';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    debugPrint("INIT STATE");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VCheck Flutter demo'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 0, height: 50),
                MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      startSDK(
                          verificationScheme:
                              VerificationSchemeType.FULL_CHECK);
                    },
                    child: const Text("Full scheme")),
                const SizedBox(width: 0, height: 20),
                MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      startSDK(
                          verificationScheme:
                              VerificationSchemeType.DOCUMENT_UPLOAD_ONLY);
                    },
                    child: const Text("Document upload")),
                const SizedBox(width: 0, height: 20),
                MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      startSDK(
                          verificationScheme:
                              VerificationSchemeType.LIVENESS_CHALLENGE_ONLY);
                    },
                    child: const Text("Face check"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> startSDK(
      {VerificationSchemeType verificationScheme =
          VerificationSchemeType.FULL_CHECK}) async {
    VCheckSDK.start(
        verificationToken: VERIFICATION_TOKEN,
        verificationScheme: verificationScheme,
        languageCode: "en",
        environment: VCheckEnvironment.DEV,
        partnerEndCallback: partnerEndCallback());

    if (!mounted) return;
  }

  Function partnerEndCallback() {
    return () {
      debugPrint("Triggered Dart callback for SDK finish");

      navigatorKey.currentState?.push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const ResultWidget(),
        ),
      );
    };
  }
}
