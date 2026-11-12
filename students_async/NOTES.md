# Practice 10 – The Data Arrives Later

## Level 1: Event loop prediction

**Predicted order:** A, C, then (after approximately two seconds) B and `6 students`.

**Actual order:** A, C, then the first Flutter frame can render while the delayed Future is waiting. After approximately two seconds: B and `6 students`. The exact relative order of the two delayed callbacks depends on when they were scheduled; record the console output from your own run here.

**Why:** `Future.delayed` schedules work for later. It does not block `main()`. `await` suspends the async function, not the whole event loop.

**Third fetch failure:** `Unhandled Exception: Instance of 'NoConnectionException'` when the returned Future is not handled.

## Level 2: mounted

When the widget is removed before the request finishes, the request may still complete. Without the mounted guard, Flutter reports an error beginning with:

`setState() called after dispose():`

Copy the exact full first error line from your Flutter console here after performing the intentional test. The state object's generated suffix varies between runs.

With `if (!mounted) return;`, the disposed widget is not updated.

## Level 3: FutureBuilder

The Future is stored in `_future` and assigned in `initState`. Switching Compact on and off rebuilds the screen but reuses the same Future. Only Retry creates another request.

## Level 4: Countdown observations

**Version A:** When leaving the screen, StreamBuilder manages and cancels its stream subscription. The countdown stops and no more ticks should be printed for the removed screen.

**Version B with `_sub.cancel()`:** Leaving the screen cancels the manually owned subscription. The generator stops at its next asynchronous suspension and no further ticks should arrive.

**Version B without `_sub.cancel()` (intentional test only):** The subscription remains active after the screen is removed. It can continue printing ticks and attempt to call `setState()` on a disposed State. Restore `_sub.cancel()` immediately after the test.

## Level 5: Save

**Incorrect version:** Calling `_api.save(n)` without awaiting it allows `Navigator.pop(context)` to run immediately. The screen can close as if saving succeeded, while the later Future fails with an unhandled `StateError`, for example:

`Unhandled Exception: Bad state: server rejected 6`

**Correct version:** Await the save operation. Pop only after success. Catch `StateError` and show its message in a SnackBar. Disable the button while saving to prevent duplicate requests.

## Final checks

- [ ] `flutter analyze` reports no issues.
- [ ] `dart format .` has been run.
- [ ] Screenshot of the error screen saved as `screenshot_error.png`.
- [ ] Screenshot of Version B mid-count saved as `screenshot_countdown.png`.
- [ ] Intentional broken-code tests have been restored to the safe versions.
