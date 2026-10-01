import 'package:flutter/material.dart';

import 'dart:async';

class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  void _start() {
    if (_timer != null) return;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _seconds++),
    );
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _reset() {
    _stop();
    setState(() => _seconds = 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _time() {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(_time(), style: const TextStyle(fontSize: 30)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: _start, child: const Text('Start')),

                const SizedBox(width: 10),

                FilledButton(onPressed: _stop, child: const Text('Stop')),

                const SizedBox(width: 10),

                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
