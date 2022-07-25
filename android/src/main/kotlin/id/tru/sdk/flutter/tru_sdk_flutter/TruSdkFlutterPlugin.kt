/*
 * MIT License
 * Copyright (C) 2020 4Auth Limited. All rights reserved
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package id.tru.sdk.flutter.tru_sdk_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import id.tru.sdk.ReachabilityDetails
import id.tru.sdk.TruSDK

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import java.lang.Exception
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import kotlinx.serialization.encodeToString
import java.io.Serializable
import java.net.URL

/** TruSdkFlutterPlugin */
class TruSdkFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var sdk: TruSDK

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    sdk = TruSDK.initializeSdk(context)
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "id.tru.sdk/flutter")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d("FlutterPlugin", "native method called")
    try {
      when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "check" -> {
          check(call.arguments as String, result)
        }
        "checkUrlWithResponseBody" -> {
          checkUrlWithResponseBody(call.arguments as String, result)
        }
        "checkWithTrace" -> {
          checkWithTrace(call.arguments as String, result)
        }
        "isReachable" -> {
          isReachable(result)
        }
        "isReachableWithDataResidency" -> {
          isReachableWithDataResidency(call.arguments as String, result)
        }
        else -> {
          result.notImplemented()
        }
      }
    } catch (e: Exception) {
      result.error("Exception", "Received an exception ${e.localizedMessage}", e)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun check(url: String, result: Result) {
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val isRequestOnMobileNetwork = sdk.check(url)
        launch(Dispatchers.Main) {
          print("Calling results on main thread")
          result.success("$isRequestOnMobileNetwork")
        }
      } catch (e: Exception) {
        launch(Dispatchers.Main) {
          result.error("Exception", "Received an exception ${e.localizedMessage}", e)
        }
      }
    }
  }

  fun checkUrlWithResponseBody(url: String, result: Result) {
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val body = sdk.checkUrlWithResponseBody(url)
        if (body != null) {
          if (body.has("code") && body.has("check_id")) {
            val success = mapOf("code" to body.get("code"), "check_id" to body.get("check_id"), "reference_id" to body.get("reference_id") )
            launch(Dispatchers.Main) {
              result.success(success)
            }

          } else if (body.has("error") && body.has("error_description")) {
            val failure = mapOf("error" to body.get("error"), "error_description" to body.get("error_description"), "check_id" to body.get("check_id"), "reference_id" to body.get("reference_id"))
            launch(Dispatchers.Main) {
              result.success(failure)
            }
          } else {
            launch(Dispatchers.Main) {
              val failure = mapOf("status" to "-1", "detail" to "Unable to decode response body.")
              val jsonData = Json.encodeToString(failure)
              result.error("Exception", jsonData, "Unable to decode response body.")
            }
          }
        } else {
          val emptyMap = emptyMap<String, Any>()
          result.success(emptyMap) //Since v0.1 does not return a body, we are returning an empty dictionary
        }
      } catch (e: Exception) {
        launch(Dispatchers.Main) {
          result.error("Exception", "Received an exception ${e.localizedMessage}", e)
        }
      }

    }
  }


  fun checkWithTrace(url: String, result: Result) {
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val traceInfo = sdk.checkWithTrace(URL(url))
        val body = traceInfo.responseBody
        if (body != null) {
          if (body.has("code") && body.has("check_id")) {
            val success = mapOf(
              "code" to body.get("code"),
              "check_id" to body.get("check_id"),
              "reference_id" to body.get("reference_id"),
              "trace" to traceInfo.trace)
            launch(Dispatchers.Main) {
              result.success(success)
            }
            println("checkWithTrace Success")

          } else if (body.has("error") && body.has("error_description")) {
            val failure = mapOf(
              "error" to body.get("error"),
              "error_description" to body.get("error_description"),
              "check_id" to body.get("check_id"),
              "reference_id" to body.get("reference_id"),
              "trace" to traceInfo.trace)
            launch(Dispatchers.Main) {
              result.success(failure)
              println("checkWithTrace Failure")
            }
          } else {
            launch(Dispatchers.Main) {
              val failure = mapOf("status" to "-1", "detail" to "Unable to decode response body.")
              val jsonData = Json.encodeToString(failure)
              result.error("Exception", jsonData, "Unable to decode response body.")
           }
          }
        } else {
          val checkWithTrace = mapOf("trace" to traceInfo.trace)
          result.success(checkWithTrace) //Since v0.1 does not return a body, we are returning an empty dictionary
          println("checkWithTrace no body")
        }
      } catch (e: Exception) {
        launch(Dispatchers.Main) {
          result.error("Exception", "Received an exception ${e.localizedMessage}", e)
        }
      }

    }
  }

  fun isReachable(result: Result) {
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val reachabilityInfo: ReachabilityDetails? = sdk.isReachable()
        launch(Dispatchers.Main) {
          if (reachabilityInfo == null) {
            val failure = mapOf("status" to "-1", "detail" to "Unable to decode reachability result.")
            val jsonData = Json.encodeToString(failure)
            result.error("ReachabilityError", jsonData, "Reachability null error")
          } else {
            val details = reachabilityInfo?.toJsonString()
            result.success(details)
          }
        }
      } catch (e: Exception) {
        launch (Dispatchers.Main) {
          try {
            val jsonData = Json.encodeToString(e)
            result.success((jsonData))
          } catch (e: Exception){
            launch(Dispatchers.Main) {
              result.error("Exception", "Received an exception ${e.localizedMessage}", e)
            }
          }
        }
      }
    }
  }

  fun isReachableWithDataResidency(dataResidency: String, result: Result) {
    CoroutineScope(Dispatchers.IO).launch {
      try {
        val reachabilityInfo: ReachabilityDetails? = sdk.isReachable(dataResidency)
        launch(Dispatchers.Main) {
          if (reachabilityInfo == null) {
            val failure = mapOf("status" to "-1", "detail" to "Unable to decode reachability result.")
            val jsonData = Json.encodeToString(failure)
            result.error("ReachabilityError", jsonData, "Reachability null error")
          } else {
            val details = reachabilityInfo?.toJsonString()
            result.success(details)
          }
        }
      } catch (e: Exception) {
        launch (Dispatchers.Main) {
          try {
            val jsonData = Json.encodeToString(e)
            result.success((jsonData))
          } catch (e: Exception){
            launch(Dispatchers.Main) {
              result.error("Exception", "Received an exception ${e.localizedMessage}", e)
            }
          }
        }
      }
    }
  }
}
