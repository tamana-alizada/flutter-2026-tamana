# Practice 9 — Put It High, Subscribe Low

## Level 1: Lift It Up

### State ownership

The shopping cart is stored in the Shell StatefulWidget,
which sits above MaterialApp.

BooksScreen receives the cart and onAdd callback.
CartScreen receives the items and onRemove callback.
CartBadge receives the count and total.

State is passed down through constructors.
Callbacks are used to request changes from the owner.

### Constructor changes

To display the total price in the cart badge:

- Constructors changed: 1
- File: lib/cart_badge.dart
- Constructor call updated: lib/books_screen.dart
- New parameter: total

### Rebuild measurement

Number of books: 6

After pressing Add once:

- BooksScreen build messages: 1
- Row debug messages: 6
- Total debug messages: 7

These are expected counts; replace them with actual
console measurements if different.

### Observation

The cart is owned by Shell, above MaterialApp.
Calling setState in Shell causes the Books screen
and all six row-building expressions to execute.

This demonstrates the cost of keeping changing state
high in the widget tree.

### Level 1 test results

- Add two books: Passed
- Badge shows 2: Passed
- Added text appears: Passed
- Cart displays both books: Passed
- Remove a book: Passed
- Badge updates after removal: Passed
- Total price displayed: Verify after Step 9


## Level 2: A Model With No Widgets

### Files created
- lib/models/book.dart
- lib/models/cart.dart

### Model responsibilities

Book stores title, author, and price.

Cart extends ChangeNotifier and manages the
shopping cart independently from the UI.

### Cart methods
- add(Book): adds a book unless already present
- remove(Book): removes a book
- clear(): removes all books

### Cart getters
- items: unmodifiable list
- count: number of books
- total: sum of book prices

### Tests
- Added two books
- Attempted duplicate addition
- Removed one book
- Expected result: 1 items, 3100 ₸
- Unmodifiable list mutation throws an error

### Observation

The model contains no BuildContext, SnackBar,
Navigator, Material widgets, or UI logic.

The no-duplicates rule is implemented only
inside Cart.add().


## Level 3: The Same App With Provider

### Provider setup

Installed the provider package.

ChangeNotifierProvider creates Cart above MaterialApp.

Shell is now a StatelessWidget.

No cart list, callbacks, or setState remain in Shell.

### State access

- CartBadge uses context.watch<Cart>().count.
- Books rows use context.watch<Cart>() to check
  whether each book is already added.
- Add buttons use context.read<Cart>().add(b).
- CartScreen uses Consumer<Cart> for its content.

### Parameter passing

The cart parameters were removed from widget
constructors.

The screens access the shared Cart through Provider.

### Experiment A: watch inside onPressed

Changed read to watch in the Add callback.

Observed result:
Tried to listen to a value exposed with provider,
from outside of the widget tree.

This is likely caused by an event handler (like a button's
onPressed) that called Provider.of without passing listen: false.
Failed assertion: 'context.owner!.debugBuilding ||
listen == false ||
debugIsInInheritedProviderUpdate'

Explanation:
watch is for subscribing during build, not for
ordinary button callbacks.

### Experiment B: read inside badge build

Changed watch to read in CartBadge.

Observed result:
No error appears. Adding an item updates the cart, but the badge
does not automatically update. It keeps its previous number
until another event causes the badge to rebuild.

Explanation:
read does not subscribe to Cart notifications.

### Conclusion

Provider removes manual cart parameter passing.

watch subscribes to changing data.
read performs actions without subscribing.
Consumer rebuilds its builder when Cart changes.


## Level 4: Scope — select and Consumer

### Quantity support

Replaced List<Book> with Map<Book, int> in the Cart model.

- items returns distinct books as an unmodifiable list.
- count returns the number of distinct books.
- qtyOf(Book) returns the quantity of a book.
- increment(Book) increases the quantity and notifies listeners.
- total multiplies each book's price by its quantity.

### Rebuild experiment

Used a temporary CartBadge on the Cart screen so the badge was active during the experiment.
| Measurement | With watch | With select |
|---|---|---|
| Badge rebuilds after 3 quantity increments | 3 | 0 |
| Badge rebuilds after removing a book | 1 | 1 |

### Consumer child optimization

Created a constant TotalLabel widget and passed it to the child parameter of Consumer<Cart>.

The label does not depend on the Cart model, so it can be reused while the total price updates.

### Subscription scope experiment

Temporarily added context.watch<Cart>() to BooksScreen.build.

Observed result: After adding a book, BooksScreen.build ran again. With three separate Add button presses, BooksScreen rebuilt three times, excluding the initial build.

Removed the broad subscription after the experiment.

### Conclusion

context.watch rebuilds the subscribed widget when Cart notifies listeners.

context.select rebuilds the subscribed widget when its selected value changes.

Consumer can rebuild dynamic content while reusing a constant child.

Subscriptions should be placed close to the UI that needs the changing data.

## Level 5: Logic on the Right Side

### Where does it live?

| Value | State category | Reason |
|---|---|---|
| Shopping cart | Provided | The cart is shared between BooksScreen, CartScreen, and CartBadge. Provider makes the same model available to all of them. |
| Search text | Ephemeral | Search text is temporary UI state used only by BooksScreen, so it belongs in the screen's local State. |
| Whether the total is expanded or collapsed | Ephemeral | This controls only the Cart screen's presentation and does not need to be shared with other screens. |
| Theme mode, if a dark-mode switch existed | Provided | Theme mode would affect the entire application and should be accessible above the screens that depend on it. |

### Model and widget responsibilities

The Cart model contains the business rules and data operations. It prevents duplicate books, manages quantities, calculates totals, and notifies listeners when data changes.

BooksScreen displays a SnackBar only when Cart.add() returns true.

CartScreen displays a confirmation dialog and calls Cart.clear() only after the user confirms.

The model does not contain BuildContext, SnackBar, Navigator, AlertDialog, or other UI code.

### Level 5 testing

- Added SnackBar: [Pass / Fail]
- Duplicate addition prevention: [Pass / Fail]
- Search field: [Pass / Fail]
- Clear confirmation — Cancel: [Pass / Fail]
- Clear confirmation — Clear: [Pass / Fail]
- Quantity and total updates: [Pass / Fail]
- flutter analyze: [Result]

### Conclusion

The final application separates business logic from UI behavior. Provider shares Cart state, select limits unnecessary rebuilds, and local UI state remains inside the appropriate widgets.
flutter pub add provider
