# Practice 11 — A Real Server

Base URL: `https://jsonplaceholder.typicode.com`

## Level 1 — Postman observations

`GET /users` returns `200 OK`, JSON content, and an array of **10 users**.
`GET /users/1` returns `200 OK` and one user object.
`GET /users/999` returns `404 Not Found` with an empty JSON object (`{}`).
`GET /users?id=3` returns a list containing one user, not a single object.
`POST /users` with JSON and `Content-Type: application/json` returns `201 Created`; the response echoes submitted data and adds an id (commonly `11`).

### Top-level user fields

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| id | number | int | No |
| name | string | String | No |
| username | string | String | No |
| email | string | String | No |
| address | object | Address | No |
| phone | string | String | No |
| website | string | String? | Optional in this model |
| company | object | record `({String name, String catchPhrase})` | No |

### Address

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| street | string | String | No |
| suite | string | String | No |
| city | string | String | No |
| zipcode | string | String | No |
| geo | object | Geo | No |

### Geo

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| lat | string | double (double.parse) | No |
| lng | string | double (double.parse) | No |

### Company

| Field | JSON type | Dart type | Nullable? |
|---|---|---|---|
| name | string | String | No |
| catchPhrase | string | String | No |
| bs | string | Not used in required company record | Not used |

## Levels 2–4 — Implementation notes

- `Geo`, `Address`, and `User` use final fields and const constructors, with `fromJson` and `toJson`.
- `website` is nullable. `phoneDigits` removes formatting except digits and `+`.
- `User` equality and hash code use the id.
- `ApiClient` owns request headers, injected `http.Client`, ten-second timeout, status checks, decoding, and debug logging.
- `UserRepository` exposes `getAll`, `getById`, and `create`; endpoint URIs use `Uri.https`.
- `UsersModel` owns loading, error, items, and saving state.
- The UI has loading/error/list states, Retry, pull-to-refresh, a detail screen, and a validated New User form.

## Level 5 — Manual verification required

## Network Tests

| Test | Expected behavior | Actual time |
|---|---|---|
| Airplane mode | NoConnectionException | 0.5 seconds |
| Dead Wi-Fi | NoConnectionException after timeout | 10 |
| DevTools timeout request screenshot | TODO — save as `screenshot_timeout.png` |
| DevTools successful 200 request screenshot | TODO — save as `screenshot_200.png` |


## Commands

```bash
flutter pub get
dart format .
flutter analyze
flutter run
```

The `package:http` import is intentionally limited to `api_client.dart` and `user_repository.dart`, matching the assignment's grep check. `ApiClient.createDefault()` constructs the default client while the injectable `ApiClient(http.Client(...))` constructor remains available for tests.
