import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _count == 0 ? null : () => setState(() => _count--),
              child: const Text('-'),
            ),

            const SizedBox(width: 30),

            Text('$_count', style: const TextStyle(fontSize: 30)),

            const SizedBox(width: 30),

            FilledButton(
              onPressed: () => setState(() => _count++),
              child: const Text('+'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
