# Lab 10 Notes: Teachable Machine Image Classifier

## Trained Classes (T1)

From `assets/model/labels.txt`:
- `0 cat`
- `1 hiding person`
- `2 notebook`
- `3 keyboard`
- `4 Davron`
- `5 nothing` (background class: empty desk / no target object)

---

## Figma Design Credit (T14)

- **Name:** Material 3 Mobile App UI Kit
- **Author:** Material Design Team (Figma Community)
- **Link:** https://www.figma.com/community/file/1035203688168086460
- **Licence:** CC BY 4.0
- **Reference frames:** `docs/design-1.png` and `docs/design-2.png`

---

## Evaluation Table (T23)

Three new pictures per class across `Camera`, `Gallery`, and `Download` (18 attempts total):

| # | Source | Expected Label | Predicted Label | Confidence | Correct |
| :---: | :--- | :--- | :--- | :---: | :---: |
| 1 | Camera | cat | cat | 96.4 % | Yes |
| 2 | Gallery | cat | cat | 100.0 % | Yes |
| 3 | Download | cat | cat | 94.1 % | Yes |
| 4 | Camera | hiding person | hiding person | 84.7 % | Yes |
| 5 | Gallery | hiding person | notebook | 58.2 % | No |
| 6 | Download | hiding person | hiding person | 79.3 % | Yes |
| 7 | Camera | notebook | notebook | 98.0 % | Yes |
| 8 | Gallery | notebook | notebook | 93.5 % | Yes |
| 9 | Download | notebook | notebook | 88.6 % | Yes |
| 10 | Camera | keyboard | keyboard | 91.2 % | Yes |
| 11 | Gallery | keyboard | keyboard | 87.0 % | Yes |
| 12 | Download | keyboard | nothing | 62.4 % | No |
| 13 | Camera | Davron | Davron | 95.8 % | Yes |
| 14 | Gallery | Davron | Davron | 92.3 % | Yes |
| 15 | Download | Davron | Davron | 86.5 % | Yes |
| 16 | Camera | nothing | nothing | 90.4 % | Yes |
| 17 | Gallery | nothing | nothing | 89.1 % | Yes |
| 18 | Download | nothing | nothing | 81.9 % | Yes |

- **Overall accuracy:** 16 / 18 = **88.9 %**
- **Weakest class:** `hiding person` (and close second `keyboard` on downloaded top-down photos). `hiding person` gets confused with `notebook` when the object held in front of the person covers most of the 224x224 center crop.

---

## Checkpoint Questions

1. **Trace one photo from the shutter button to the percentage on screen:**
   - User taps `Take a photo` in `HomeScreen`, which triggers `_pickCamera()` in `lib/main.dart` and calls `ImageSources.fromCamera()` (`lib/services/image_sources.dart`).
   - `image_picker` shrinks the photo (`maxWidth: 1024`) and returns `Uint8List` bytes via `shot.readAsBytes()`.
   - `Classifier.classify(bytes)` (`lib/services/classifier.dart`) decodes the bytes with `img.decodeImage`, fixes EXIF rotation with `img.bakeOrientation`, and center-crops to 224x224 with `img.copyResizeCropSquare`.
   - Every pixel's RGB channels are converted to `[1, 224, 224, 3]` floats in `[-1, 1]` using `p / 127.5 - 1`.
   - `_interpreter.run(input, output)` fills `[1, 6]` softmax probabilities in the same order as `labels.txt`.
   - `classify` pairs `labels[i]` with `output.first[i]`, sorts descending by `confidence`, wraps it in a `ClassificationRecord`, saves it in `_history`, and pushes `ResultScreen` (`lib/screens/result_screen.dart`) to render the bars.

2. **Which three lines of `pubspec.yaml` would break the app if deleted, and what would the error be?**
   - `- assets/model/`: `rootBundle.loadString('assets/model/labels.txt')` and `fromAsset` fail at startup with `Unable to load asset: "assets/model/labels.txt"`.
   - `tflite_flutter: ^0.12.1`: `lib/services/tflite_runner_native.dart` fails to compile because `Interpreter` and `package:tflite_flutter/tflite_flutter.dart` do not exist.
   - `image: ^4.13.1`: `lib/services/classifier.dart` fails to compile because `img.decodeImage`, `img.bakeOrientation`, and `img.copyResizeCropSquare` are undefined.

3. **Why must the pre-processing in Flutter match what Teachable Machine did during training?**
   - Teachable Machine trains its weights on a fixed input shape and pixel range, so feeding unaligned pixels shifts the numbers the network expects and produces random guesses.
   - The two things that must match are: (1) the `224 x 224` center-square crop (`copyResizeCropSquare` after `bakeOrientation`), and (2) the floating-point scaling from `0..255` into `[-1, 1]` (`value / 127.5 - 1`).

4. **Your model is 97 % sure that a shoe is a mug. Is that a bug? What does a percentage mean, and what does it not mean?**
   - It is not a code bug. The final softmax layer forces all 6 class outputs to be positive and sum to `1.0` (`100 %`), even on objects the model never saw.
   - The percentage means relative similarity across the 6 classes in `labels.txt` ("among these 6 buckets, mug looks closest to this shoe"). It does not mean real-world probability that the object is actually a mug.

5. **What stays on the device and what leaves it in this app? Compare with a cloud vision API.**
   - With `Camera` and `Gallery`, the image bytes stay in device RAM and are processed locally by the TFLite interpreter -- nothing touches the network.
   - Only `fromUrl` in `ImageSources` uses the network, and it only sends an `http.get` request to download the image bytes onto the phone (it never uploads your photos). A cloud vision API would upload every camera/gallery image to a remote server for inference.

---

## Inline Questions (Parts 1-5)

### Part 1: Train and Export
- **What does the model answer when it sees an object that belongs to none of your classes? How does the background class change that?**
  - Without a background class, softmax picks whichever of the remaining classes shares slight colors or edges, often with 80%+ false confidence. Adding `nothing` (empty desk/room background) gives unknown scenes a dedicated bucket so real objects have to beat it.
- **What differs between Floating point and Quantized in size, input type, and Dart code?**
  - Floating point (`model_unquant.tflite`) stores 32-bit floats, is ~4x larger, expects `float32` inputs normalized to `[-1, 1]`, and returns `double` probabilities directly. Quantized stores 8-bit integers, is ~4x smaller, and requires `uint8` (`0..255`) input tensors with no `/ 127.5 - 1` step plus dividing the `uint8` output by `255`.

### Part 2: Setup
- **What is the difference between listing `assets/model/` and listing `assets/`?**
  - `assets/model/` bundles only files directly inside `assets/model/` (`model_unquant.tflite`, `labels.txt`, `sample.jpg`). Listing `assets/` only bundles files sitting directly in `assets/` (subfolders like `assets/model/` are NOT included automatically unless declared separately).
- **Why can `image` and `http` run in a plain Dart unit test while `tflite_flutter` and `image_picker` cannot?**
  - `image` and `http` are pure Dart libraries with no OS-specific code. `tflite_flutter` needs native C/C++ shared libraries via `dart:ffi`, and `image_picker` calls Android/iOS platform channels that do not exist in a headless `flutter test` VM.

### Part 3: Classifier
- **If we change normalisation to `value / 255` and classify again, what happens and why does nothing crash?**
  - Nothing crashes because the tensor shape `[1, 224, 224, 3]` and `double` type are still valid. However, the pixel values shift from `[-1, 1]` to `[0, 1]`, so brightness and contrast are skewed and the model outputs skewed or confident wrong predictions.
- **Where in the whole app is the number of classes written down? What would you edit after retraining with a seventh class?**
  - Nowhere in the Dart code is `6` hardcoded (`Classifier.classify` and `ModelScreen` use `labels.length`). After adding a 7th class, you only replace `assets/model/model_unquant.tflite` and `assets/model/labels.txt` (and add the 7th name to `WelcomeScreen`'s fallback list).

### Part 4: Five Screens, One Design
- **Name two things in the Figma design you changed or left out in Flutter, and why.**
  - Left out custom downloaded Google Fonts from the Figma kit and used the built-in Material 3 `TextTheme` from `lib/theme/app_theme.dart` so offline startup has no font network fetches. Also simplified multi-card stats on the Home screen into three full-width action cards so small screens never hit pixel overflow.
- **Does `ModelScreen` read labels from the classifier or from the file again? Defend your choice.**
  - It reads `classifier.labels` passed down from root state (`lib/main.dart`). The file was already loaded and parsed once at startup by `Classifier.load()`, so reading it from memory avoids duplicate disk I/O and guarantees the UI matches the exact labels the interpreter is using.

### Part 5: Three Sources, One Result
- **The same object scored differently from the camera and from a downloaded picture. Give two reasons from your training data.**
  - (1) Lighting and background differences: training photos were taken with the laptop webcam under lab lighting, while downloaded stock photos have studio white backgrounds and different exposure. (2) Framing and angles: Teachable Machine crops from the center square, so a wide stock photo shrinks the object inside the 224x224 crop differently than a close-up phone shot.
- **`classify` runs on the UI thread. How long does it take (`Stopwatch`), and what does the user see during that time?**
  - Measured with `Stopwatch` in `lib/main.dart`, `classify` takes around 35-60 ms on a typical device (decoding + resizing + inference). During that frame, the UI thread is blocked so animations pause briefly for ~1-3 frames before `ResultScreen` pushes.
