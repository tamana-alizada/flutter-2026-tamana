# Reading Club — Flutter Lab 1

A Flutter application for browsing reading-club books and meetings, managing favourites, borrowing and returning copies, and maintaining a reader profile. Book data and the profile are stored **in memory**; restarting the application resets them to seed data.

## Features

- Books, Favourites, and Profile tabs using `NavigationBar`
- Search, genre filters, optional past meetings, and responsive list/grid
- Book details with a local asset image, countdown, About and Borrowers tabs
- Borrow/Return confirmation, available-place counts, and current-reader highlighting
- Add/Edit form with validation, date/time pickers, delayed save, and unsaved-change confirmation
- Light, Dark, and System theme options; About and Reset Data drawer actions

## Run

```sh
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

For a smaller viewport, use Chrome's device toolbar. To test themes, open the Profile tab and choose Light or Dark.

## Screenshots

Capture **actual screenshots** from the running application and save them in `screenshots/`:

1. `screenshots/phone-light.png` — Books tab at phone width in Light mode
2. `screenshots/phone-dark.png` — Books tab at phone width in Dark mode
3. `screenshots/tablet-grid.png` — Books tab at tablet width showing the grid

The screenshot files are not included in this archive because they must be captured from your own running application.

## Decisions

The list of books and the reader profile live in `AppShell` State so the tabs use one source of truth. Detail screens receive the selected book and callbacks through typed route arguments so actions update the shell instead of creating independent data. The Add/Edit form returns a `Book` through `Navigator.pop`, and the caller updates the list only after receiving a non-null result. `LayoutBuilder` chooses a list at narrow widths and a grid at wider widths based on the available constraints. `PopScope` compares the current form fields with their original values to warn before discarding unsaved changes. The book model protects its borrowers list against external mutation and uses `copyWith` for updates. With Week 9 tools, I would add persistent storage so books, favourites, and the profile survive application restarts.

## Submission checks

- [ ] `flutter analyze` reports **No issues found!**
- [ ] `dart format .` has no remaining changes
- [ ] All three screenshots have been captured and added
- [ ] Git history has at least 12 meaningful commits (`git log --oneline`)
- [ ] Borrow/Return, Add/Edit, Reset Data, responsive layout, and both themes have been manually tested

The Git commit history is kept in your original repository, not in this exported ZIP.
