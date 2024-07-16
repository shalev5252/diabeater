import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_onboarding.dart';

void main() {
  group('Test Onboarding screen', () {
    testWidgets('Test login button',
        (WidgetTester tester) async => TestOnboarding.test_login(tester));
    testWidgets('Test signup button',
        (WidgetTester tester) async => TestOnboarding.test_signup(tester));
  });
}
