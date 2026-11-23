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
