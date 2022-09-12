# tru.ID SDK For Flutter
[![License][license-image]][license-url]

The only purpose of the SDK is to force the data cellular connectivity prior to call a public URL, and will return the following JSON response

* **Success**
When the data connectivity has been achieved and a response has been received from the url endpoint
```
{
"http_status": string, // HTTP status related to the url
"response_body" : { // optional depending on the HTTP status
           ... // the response body of the opened url 
           ... // see API doc for /device_ip and /redirect
                },
"debug" : {
    "device_info": string, 
    "url_trace" : string
          }
}
```

* **Error** 
When data connectivity is not available and/or an internal SDK error occurred

```
{
"error" : string,
"error_description": string
}
```
Potential error codes: `sdk_no_data_connectivity`, `sdk_connection_error`, `sdk_redirect_error`, `sdk_error`.


## Installation

To add the package `tru_sdk_flutter` to your app project:

1. Depend on it. Open the `pubspec.yaml` file located inside the app folder and add the following under the dependencies heading:

```yaml
	`tru_sdk_flutter: ^x.y.z`
```

2. Install it
   - From the terminal: Run:
   ```bash
   flutter pub get
   ```
   - From Android Studio/IntelliJ: Click **Packages get** in the action ribbon at the top of pubspec.yaml.
   - From VS Code: Click **Get Packages** located in right side of the action ribbon at the top of pubspec.yaml.

## Compatibility

- [Android](../tru-sdk-android#compatibility)
- [iOS](../tru-sdk-ios#compatibility)


## Usage

* Is the [device eligible](https://developer.tru.id/docs/reference/utils#tag/coverage/operation/get-public-coverage-by-device-ip) for tru.ID silent authentication?

```dart
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';

// ...
   TruSdkFlutter sdk = TruSdkFlutter();

   Map<Object?, Object?> reach = await sdk.openWithDataCellular(
      "https://eu.api.tru.id/public/coverage/v0.1/device_ip", false);
   if (reach.containsKey("error")) {
      // Network connectivity error
   } else if (reach.containsKey("http_status")) {
      
      if (reach["http_status"] == 200) {
         // device is eligible for tru.ID
         Map body = reach["response_body"] as Map<dynamic, dynamic>;
         Coverage cv = Coverage.fromJson(body);
      } else if (reach["status"] == 400) {
         // MNO not supported
      } else if (reach["status"] == 412) {
         // Not a mobible IP
      } else {
         // No Data Connectivity - Ask the end-user to turn on Mobile Data
      }

   }

```

* How to open a check URL return by the [PhoneCheck API](https://developer.tru.id/docs/phone-check) or [SubscriberCheck API](https://developer.tru.id/docs/subscriber-check)
```dart
import 'package:tru_sdk_flutter/tru_sdk_flutter.dart';

// ...
   TruSdkFlutter sdk = TruSdkFlutter();

   Map<Object?, Object?> result = await sdk.openWithDataCellular(checkUrl, false);
      if (result.containsKey("error")) {
         // error
      } else if (reach.containsKey("http_status")) {
         if (result["http_status"] == 200) {
          Map body = result["response_body"] as Map<dynamic, dynamic>;
            if (body["code"] != null) {
               CheckSuccessBody successBody = CheckSuccessBody.fromJson(body);
               // send code, check_id and reference_id to back-end 
               // to trigger a PATCH /checks/{check_id}
            } else {
               CheckErrorBody errorBody = CheckErrorBody.fromJson(body);
               // error
            }   
         } else if (result["status"] == 400) {
          // MNO not supported
         } else if (result["status"] == 412) {
            // Not a mobible IP
         } else {
            // No Data Connectivity - Ask the end-user to turn on Mobile Data
         }
   }

```

## Example Demo

There's an embedded example demo is located in the `example` directory, see [README](./example/README.md)


## Meta

Distributed under the MIT license. See `LICENSE` for more information.

[https://github.com/tru-ID](https://github.com/tru-ID)
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
