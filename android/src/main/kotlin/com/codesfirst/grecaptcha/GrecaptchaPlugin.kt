package com.codesfirst.grecaptcha

import android.app.Activity
import androidx.annotation.NonNull
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.safetynet.SafetyNet
import com.google.android.gms.tasks.OnFailureListener
import com.google.android.gms.tasks.OnSuccessListener

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.Executor
import com.google.android.gms.safetynet.SafetyNetApi
import com.google.android.gms.safetynet.SafetyNetApi.RecaptchaTokenResponse


/** GrecaptchaPlugin */
class GrecaptchaPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private var activity: Activity? = null

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    this.activity = null;
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "grecaptcha")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "isSupported" -> {
          result.success(true)
        }
        "verify" -> {
          if (activity == null) {
            result.error(
              "grecaptcha",
              "No activity found, this plugin works with Activity only.",
              null
            )
            return
          }
          val siteKey: String? = call.argument("key")

          SafetyNet.getClient(activity).verifyWithRecaptcha(siteKey)
            .addOnSuccessListener { response -> result.success(response.tokenResult) }
            .addOnFailureListener { e ->
              e.printStackTrace()
              result.error(
                "grecaptcha",
                "Verification using reCaptcha has failed", null
              )
            }


        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
