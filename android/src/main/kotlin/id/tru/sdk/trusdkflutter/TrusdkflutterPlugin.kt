package id.tru.sdk.trusdkflutter

import android.content.Context
import androidx.annotation.NonNull
import id.tru.sdk.TruSDK

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.coroutines.launch

/** TrusdkflutterPlugin */
class TrusdkflutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will be the communication between Flutter and native Android
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
    try {
      if (call.method == "getPlatformVersion") {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      } else if (call.method == "check") {
        check(call.arguments as String, result)
      } else if (call.method == "checkWithTrace") {
        checkWithTrace(call.arguments as String, result)
      } else if (call.method == "isReachable") {
        isReachable(result)
      }else {
        result.notImplemented()
      }
    } catch (e: Exception) {
      result.error("Exception", "Received an exception ${e.localizedMessage}", e)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun check(url: String, result: Result) {
//    val isRequestOnMobileNetwork = sdk.openCheckUrl(url)
  }

  fun checkWithTrace(url: String, result: Result) {
//    val traceInfo = sdk.checkWithTrace(url)
  }

  fun isReachable(result: Result) {
    val details = sdk.isReachable()
//    launch {
//
//    }
  }
}
