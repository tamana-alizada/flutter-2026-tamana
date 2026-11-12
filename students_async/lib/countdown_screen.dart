import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _version = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Version A')),
              ButtonSegment(value: 1, label: Text('Version B')),
            ],
            selected: {_version},
            onSelectionChanged: (selection) {
              setState(() => _version = selection.first);
            },
          ),
          Expanded(
            child: _version == 0
                ? const CountdownStreamBuilder()
                : const CountdownWithSubscription(),
          ),
        ],
      ),
    );
  }
}

// Version A: StreamBuilder manages and cancels its own stream subscription.
class CountdownStreamBuilder extends StatefulWidget {
  const CountdownStreamBuilder({super.key});

  @override
  State<CountdownStreamBuilder> createState() => _CountdownStreamBuilderState();
}

class _CountdownStreamBuilderState extends State<CountdownStreamBuilder> {
  late final Stream<int> _stream = countdown(10);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stream,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 10;
        return Center(
          child: Text(
            '$value',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        );
      },
    );
  }
}

// Version B: the State owns the subscription and must cancel it in dispose().
class CountdownWithSubscription extends StatefulWidget {
  const CountdownWithSubscription({super.key});

  @override
  State<CountdownWithSubscription> createState() =>
      _CountdownWithSubscriptionState();
}

class _CountdownWithSubscriptionState extends State<CountdownWithSubscription> {
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) {
      if (!mounted) return;
      setState(() => _left = i);
    });
  }

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$_left', style: Theme.of(context).textTheme.displayLarge),
    );
  }
}
