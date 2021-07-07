# trusdkflutter

Flutter SDK for tru.ID: Blazingly fast phone verification. Exposes APIs for instant, invisible strong authentication.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]


## Getting Started
This project is a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Installation
To add the package tru_sdk_flutter to your app:

1. Depend on it 
   * Open the `pubspec.yaml` file located inside the app folder and add 
	`tru_sdk_flutter: ^0.0.1` 
     under the dependencies.

2. Install it 
   * From the terminal: Run ‘flutter pub get’ **OR**
   * From Android Studio/IntelliJ: Click **Packages get** in the action ribbon at the top of pubspec.yaml.
   * From VS Code: Click **Get Packages** located in right side of the action ribbon at the top of pubspec.yaml.

3. Import it
   * Add a corresponding import statement in the Dart code
  `import 'package:trusdkflutter/trusdkflutter.dart';`
4. Stop and restart the app, if necessary


## Usage

```dart
import 'package:trusdkflutter/trusdkflutter.dart';
// ...
Trusdkflutter sdk = Trusdkflutter();
        String? result = await sdk.check(checkDetails.url);

```
## Example
The SDK contains an embedded example to make building and testing the SDK bridge easier.
Before you begin, you will need to:
- Install [Flutter](https://flutter.dev/docs/get-started/install)
- Set up an [editor](https://flutter.dev/docs/get-started/editor)
- Install the [Flutter and Dart plugins for Android](https://flutter.dev/docs/get-started/editor?tab=androidstudio)
- For iOS: Xcode 12+ required
- For Android: Android Studio version 3.0 or later
- For tru.ID PhoneCheck set up a [local tunnel base](https://developer.tru.id/docs/phone-check/quick-start) and change the baseURL on the lib/main.dart file of the Example Project accordingly.


## Release History
* 0.0.1
    * Initial implementation  
  

## Meta

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/tru-ID](https://github.com/tru-ID)

[swift-image]:https://img.shields.io/badge/swift-5.0-green.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

