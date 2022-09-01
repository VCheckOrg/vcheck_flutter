package com.vcheck.vcheck_flutter

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.vcheck.sdk.core.VCheckSDK
import com.vcheck.sdk.core.domain.VCheckEnvironment
import com.vcheck.sdk.core.domain.VerificationSchemeType
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class VcheckFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var context: Context
  private lateinit var activity: Activity

  private var verificationToken: String? = null

  private var verifScheme: VerificationSchemeType? = null

  private var environment: VCheckEnvironment? = VCheckEnvironment.DEV

  private var languageCode: String? = null

  private var showPartnerLogo: Boolean? = false
  private var showCloseSDKButton: Boolean? = true

  private var colorBackgroundTertiary: String? = null
  private var colorBackgroundSecondary: String? = null
  private var colorBackgroundPrimary: String? = null
  private var colorTextSecondary: String? = null
  private var colorTextPrimary: String? = null
  private var colorBorders: String? = null
  private var colorActionButtons: String? = null
  private var colorIcons: String? = null

  /// The MethodChannel that does communication between Flutter and native Android
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.vcheck.vcheck_flutter")
      channel.setMethodCallHandler(this)
      context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
        "start" -> {
          startSDKFlow(call, result)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  private fun startSDKFlow(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {

      verificationToken = call.argument("verifToken")

      verifScheme = convertStrToVerifScheme(call.argument("verifScheme"))

      environment = convertStrToEnvironment(call.argument("environment"))

      languageCode = call.argument("languageCode")

      showPartnerLogo = call.argument("showPartnerLogo")
      showCloseSDKButton = call.argument("showCloseSDKButton")

      colorBackgroundTertiary = call.argument("colorBackgroundTertiary")
      colorBackgroundSecondary = call.argument("colorBackgroundSecondary")
      colorBackgroundPrimary = call.argument("colorBackgroundPrimary")
      colorTextSecondary = call.argument("colorTextSecondary")
      colorTextPrimary = call.argument("colorTextPrimary")
      colorBorders = call.argument("colorBorders")
      colorActionButtons = call.argument("colorActionButtons")
      colorIcons = call.argument("colorIcons")

      result.success("VCheck: Android SDK start() method called")

      launchSDK(activity)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
      channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      activity = binding.activity
  }

  private fun launchSDK(activity: Activity) {

    setColorsIfPresent()

    VCheckSDK
      .verificationToken(verificationToken!!)
      .verificationType(verifScheme!!)
      .languageCode(languageCode!!)
      .environment(environment!!)
      .showPartnerLogo(showPartnerLogo!!)
      .showCloseSDKButton(showCloseSDKButton!!)
      .partnerEndCallback {
        onVCheckSDKFlowFinish()
      }
      .start(activity)
  }

  private fun onVCheckSDKFlowFinish() {

      channel.invokeMethod("onFinish", null)
  }

  private fun setColorsIfPresent() {
      colorActionButtons?.let {
        VCheckSDK.colorActionButtons(it)
      }
      colorBorders?.let {
        VCheckSDK.colorBorders(it)
      }
      colorTextPrimary?.let {
        VCheckSDK.colorTextPrimary(it)
      }
      colorTextSecondary?.let {
        VCheckSDK.colorTextSecondary(it)
      }
      colorBackgroundPrimary?.let {
        VCheckSDK.colorBackgroundPrimary(it)
      }
      colorBackgroundSecondary?.let {
        VCheckSDK.colorBackgroundSecondary(it)
      }
      colorBackgroundTertiary?.let {
        VCheckSDK.colorBackgroundTertiary(it)
      }
      colorIcons?.let {
          VCheckSDK.colorIcons(it)
      }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    //Stub
  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    //Stub
  }
  override fun onDetachedFromActivity() {
    //Stub
  }

  private fun convertStrToVerifScheme(str: String?): VerificationSchemeType? {
    return VerificationSchemeType.values().firstOrNull {
      it.name.lowercase() == str
    }
  }

  private fun convertStrToEnvironment(str: String?): VCheckEnvironment? {
    return VCheckEnvironment.values().firstOrNull {
      it.name.lowercase() == str
    }
  }
}