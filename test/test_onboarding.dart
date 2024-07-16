import 'package:diabeater/screens/home/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestOnboarding {
  static void test_login(WidgetTester tester) async {
    await tester.pumpWidget(const DiabeaterOnboarding());
    const key = Key("btn_login");
    await tester.pumpWidget(MaterialApp(key: key, home: Container()));
    expect(find.byKey(key), findsOneWidget);
  }

  static void test_signup(WidgetTester tester) async {
    await tester.pumpWidget(const DiabeaterOnboarding());
    const key = Key("btn_signup");
    await tester.pumpWidget(MaterialApp(key: key, home: Container()));
    expect(find.byKey(key), findsOneWidget);
  }
}
