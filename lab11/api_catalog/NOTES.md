# Lab 11 Notes

## Part 1

1. From product.json:
   - number: price (9.99)
   - list of strings: tags (["beauty", "mascara"])
   - nested object: dimensions
   - list of objects: reviews

2. /products/0 returns status 404 and body:
   {"message":"Product with id '0' not found"}

## Part 2

1. If the server sends 10, jsonDecode makes it an int. Doing json['price'] as double crashes at runtime with a TypeError (not compile time because the map values are dynamic).

2. Testing with a saved file works offline, runs way faster, and doesn't break if the API goes down or changes the data.

## Part 4

1. With ?delay=3000, if you leave the screen before the response comes back, BlocProvider closes the Cubit. Without the isClosed check, calling emit() after close throws a StateError ("Cannot emit new states after calling close").

2. Dart compares class instances by reference by default, not by their field values, so two ProductsLoaded([...]) objects aren't equal unless you override == and hashCode (or use Equatable). That's why the test uses isA<...>() instead.

## Part 5 (T15)

With delay=3000 on search, searching "phone" and right away searching "laptop" cancels the first "phone" request because of restartable(). Only the "laptop" results show up and "phone" never overwrites them.

## Checkpoint Questions

1. Trace of one product from HTTP response to a row on screen:
   - String (response.body) in lib/data/product_api.dart (_get)
   - Map<String, dynamic> (jsonDecode) in lib/data/product_api.dart (_get)
   - ProductPage / Product (fromJson) in lib/models/product_page.dart and lib/models/product.dart
   - ProductsLoaded state in lib/cubit/products_cubit.dart (load / loadMore)
   - ProductTile widget on screen in lib/screens/products_screen.dart and lib/widgets/product_tile.dart

2. Errors getProducts can hit and what state the user sees:
   - Timeout (TimeoutException) -> ApiException -> ProductsError("Request timed out. Please try again.")
   - No internet / dropped connection (http.ClientException) -> ApiException -> ProductsError("No internet connection. Check your network.")
   - Non-200 status code (like 404 or 500) -> ApiException -> ProductsError("Server answered ...")
   - Invalid JSON (FormatException) -> ApiException -> ProductsError("Server returned an unexpected response.")

3. Cubit vs Bloc:
   - Use Cubit for simple method-driven state changes like the product list (load, refresh, loadMore) or details screen, where you just call a function and emit loading/loaded/error.
   - Use Bloc when you need event streams and concurrency control like search, where events (SearchSubmitted, SearchCleared) can be cancelled/transformed with restartable().

4. restartable() cancels the previous event handler whenever a new SearchSubmitted arrives, so its late emit is ignored. With the default transformer (concurrent/sequential), the older slower search could finish after the newer one and overwrite the newer results on screen.

5. Why widgets should never call http.get or read a Map directly:
   - Hard to test and maintain: mixing network calls with UI means you can't unit test logic without a real network or widget tree, and rebuilding a widget could accidentally fire duplicate requests.
   - No type safety: reading raw Map keys in widgets causes runtime crashes on typos or missing fields instead of catching mistakes at compile time in models.
