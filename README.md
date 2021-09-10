# tru.ID SDK For Flutter

## Getting Started

Before you begin, you will need to:

- For iOS: Xcode 12+ required
- For Android: Android Studio version 3.0 or later
- A mobile phone with mobile data connection.

## Installation

To add the package `tru_sdk_flutter` to your app project:

1. Depend on it. Open the `pubspec.yaml` file located inside the app folder and add the following under the dependencies heading:

```yaml
	`tru_sdk_flutter: ^0.0.2`
```

2. Install it
   - From the terminal: Run:
   ```bash
   flutter pub get
   ```
   - From Android Studio/IntelliJ: Click **Packages get** in the action ribbon at the top of pubspec.yaml.
   - From VS Code: Click **Get Packages** located in right side of the action ribbon at the top of pubspec.yaml.

## Compatibility

For Android, this SDK requires a minimum API level of **21** (Android 5).

## Usage

```dart
import 'package:trusdkflutter/trusdkflutter.dart';
// ...
Trusdkflutter sdk = Trusdkflutter();

await sdk.check(checkUrl);
```

## Example Demo

The SDK contains an embedded example to make building and testing the SDK bridge easier.

The example project is located in the `example` directory.

This SDK uses the **tru.ID** dev server as the example server. To get setup:

Create a [tru.ID account](https://developer.tru.id/signup).

Install the tru.ID CLI via:

```bash
npm i -g @tru_id/cli
```

Set up the CLI with the **tru.ID** credentials which can be found within the tru.ID [console](https://developer.tru.id/console).

Install the **tru.ID** CLI [development server plugin](https://github.com/tru-ID/cli-plugin-dev-server).

Create a new **tru.ID** project within the root directory via:

```bash
tru projects:create flutter-sdk-server --project-dir .
```

Run the development server, pointing it to the directory containing the newly created project configuration. This will also open up a localtunnel to your development server, making it publicly accessible to the Internet so that your mobile phone can access it when only connected to mobile data.

```bash
tru server -t --project-dir .
```

In `example/lib/main.dart` , replace `base_url` with your development server URL.

It may be a good idea to work on the native Android or iOS example projects in separate windows/IDEs. Android Studio will provide a banner suggesting this.

Android Example Project\
tru-sdk-flutter/example/android

iOS Example\
tru-sdk-flutter/example/ios

Don't forget to make sure Cocoapods installed on your machine.

## Release History

- 0.0.1
  - Initial implementation

## Troubleshooting

[Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.5.1, expected version is 1.1.15.](https://github.com/flutter/flutter/issues/83834)

## Meta

Distributed under the MIT license. See `LICENSE` for more information.

[https://github.com/tru-ID](https://github.com/tru-ID)
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
