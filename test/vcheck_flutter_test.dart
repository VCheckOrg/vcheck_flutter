import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vcheck_flutter/vcheck_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('vcheck_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
