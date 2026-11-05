import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:shop/main.dart';
import 'package:shop/models/cart.dart';

void main() {
  testWidgets('Shop app starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(create: (_) => Cart(), child: const Shell()),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}