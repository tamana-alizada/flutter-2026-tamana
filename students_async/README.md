# Practice 10 – The Data Arrives Later

This is the completed source implementation for the five levels in the assignment.

## 1. Create the Flutter project

```bash
flutter create students_async
cd students_async
```

## 2. Copy the supplied files

Copy the `lib` folder and `analysis_options.yaml` from this package into the root of `students_async`, replacing the generated `lib` folder and analysis options file. Copy `NOTES.md` into the project root too.

The project structure should be:

```text
students_async/
├── analysis_options.yaml
├── NOTES.md
├── lib/
│   ├── main.dart
│   ├── api/
│   │   ├── fake_api.dart
│   │   └── countdown.dart
│   ├── widgets/
│   │   ├── loading_view.dart
│   │   ├── error_view.dart
│   │   ├── empty_view.dart
│   │   └── student_list.dart
│   ├── students_screen.dart
│   ├── students_future_screen.dart
│   └── countdown_screen.dart
└── pubspec.yaml
```

## 3. Get packages and run

```bash
flutter pub get
flutter run
```

## 4. Test Level 1

Temporarily add the following inside `main()`, before `runApp`, to observe the event-loop order:

```dart
print('A');
Future.delayed(const Duration(seconds: 2), () => print('B'));
print('C');

final api = FakeApi();
api.fetchStudents().then((list) => print('${list.length} students'));
```

Add the `FakeApi` import to `main.dart` for this temporary test. The expected order begins with A, C; the delayed output appears later. For the third-failure test, call `fetchStudents()` three times and observe the unhandled error from the third call. Remove all experiments and the temporary import afterward.

To demonstrate blocking, temporarily replace the `await Future.delayed(...)` in `fake_api.dart` with `sleep(const Duration(seconds: 2))` and import `dart:io`. The first frame will be delayed. Restore the original asynchronous delay immediately.

## 5. Test Level 2

Open **By hand**:
- See the spinner for about two seconds.
- See the six students.
- Tap Retry twice after the initial successful request; the third total fetch fails and displays the Error screen.
- Tap Retry again; the next request succeeds.
- To test the empty state, temporarily change `final _api = FakeApi();` to `final _api = FakeApi(empty: true);`.

To test `mounted`, temporarily remove both `if (!mounted) return;` guards, open the screen and navigate Back before the request finishes. Restore both guards after observing the error.

## 6. Test Level 3

Open **FutureBuilder**:
- Wait for the students.
- Switch Compact on and off several times.
- The console should show only one fetch request.
- Retry is the only action that creates another Future.

Do not put `_api.fetchStudents()` directly in the `FutureBuilder`'s `future:` property. That would create a new request on rebuild.

## 7. Test Level 4

Open **Countdown**, then select Version A or Version B.
- Both count from 10 down to 0.
- In Version B, leave the screen while it is counting. The subscription is cancelled in `dispose`.
- For the intentional leak test only, comment out `_sub.cancel()`, repeat, observe the continuing ticks/error, then restore the cancellation.

## 8. Test Level 5

On **By hand**, tap Save:
- The first Save succeeds and returns to Home.
- Open By hand again and tap Save. The second Save request fails and displays a SnackBar.
- The Save button is disabled and shows a spinner while the request is in progress.

The By hand screen shares one `FakeApi` instance across visits, so the save counter persists: the first Save succeeds and the next Save attempt fails as required.

## 9. Format and analyze

From the project root:

```bash
dart format .
flutter analyze
```

Resolve any environment-specific analyzer warnings before submission.

## 10. Screenshots

Capture and save these from your running emulator/device into the project root:
- `screenshot_error.png`: the By hand error screen with Retry visible.
- `screenshot_countdown.png`: Version B while the countdown is in progress.

## 11. GitHub submission

```bash
git init
git add .
git commit -m "Complete Practice 10 async Flutter lab"
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL
git push -u origin main
```

Do not commit the intentional broken test versions. Commit the restored, working code.
