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
import id.tru.sdk.TruSDK

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import java.lang.Exception
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject
import java.net.URL

class TruSdkFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
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
                "openWithDataCellular" -> {
                    openWithDataCellular(call.arguments as Map<String, Any>, result)
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

    fun openWithDataCellular(args: Map<String, Any>, result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                var debug: Boolean = false
                if (!args.containsKey("url")) {
                    val failure =
                        mapOf("error" to "sdk_error", "error_description" to "invalid url")
                    result.success(failure)
                }
                if (args.containsKey("debug")) {
                    debug = args["debug"] as Boolean
                }

                val body = sdk.openWithDataCellular(URL(args["url"] as String?), debug)
                var map: Map<String, *> = body.toMap()
                launch(Dispatchers.Main) {
                    result.success(map)
                }
            } catch (e: Exception) {
                launch(Dispatchers.Main) {
                    val failure = mapOf(
                        "error" to "sdk_error",
                        "error_description" to "Internal error: ${e.localizedMessage}"
                    )
                    result.success(failure)
                }
            }
        }
    }

    // convenient method to convert a JSON into a Map
    fun JSONObject.toMap(): Map<String, *> = keys().asSequence().associateWith {
        when (val value = this[it]) {
            is JSONArray -> {
                val map = (0 until value.length()).associate { Pair(it.toString(), value[it]) }
                JSONObject(map).toMap().values.toList()
            }
            is JSONObject -> value.toMap()
            JSONObject.NULL -> null
            else -> value
        }
    }
}
