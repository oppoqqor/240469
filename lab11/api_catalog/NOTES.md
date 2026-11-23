# Lab 11 Notes

## Part 1 — Setup

1. **Field types in `test/fixtures/product.json`:**
   - Number: `price` (`9.99`, also `weight`: `4`, `id`: `1`, `rating`: `2.56`)
   - List of strings: `tags` (`["beauty", "mascara"]`, also `images`)
   - Nested object: `dimensions` (`{"width": 15.14, "height": 13.08, "depth": 22.99}`, also `meta`)
   - List of objects: `reviews` (list of review maps with `rating`, `comment`, `date`, `reviewerName`, `reviewerEmail`)

2. **`/products/0` response:**
   - Status code: `404`
   - Body: `{"message":"Product with id '0' not found"}`
