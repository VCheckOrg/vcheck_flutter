import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vcheck_flutter/vcheck_flutter.dart';
import 'vcheck_flutter_platform_interface.dart';

const methodChannel = MethodChannel("com.vcheck.vcheck_flutter");

/// An implementation of [VcheckFlutterPlatform] that uses method channels.
class MethodChannelVcheckFlutter extends VcheckFlutterPlatform {
  /// The method channel used to interact with the native platform.

  Function? _finishAction;

  @override
  void start(
      {required String verificationToken,
      required VerificationSchemeType verificationScheme,
      required String languageCode,
      required Function partnerEndCallback,
      VCheckEnvironment? environment,
      bool? showPartnerLogo,
      bool? showCloseSDKButton,
      String? colorBackgroundTertiary,
      String? colorBackgroundSecondary,
      String? colorBackgroundPrimary,
      String? colorTextSecondary,
      String? colorTextPrimary,
      String? colorBorders,
      String? colorActionButtons,
      String? colorIcons}) async {
    methodChannel.setMethodCallHandler((methodCall) async {
      debugPrint("Caught method call with Dart handler: ${methodCall.method}");
      switch (methodCall.method) {
        case "onFinish":
          Future.delayed(const Duration(milliseconds: 500), () {
            _finishAction!();
          });
          return;
        default:
          throw MissingPluginException('Not Implemented');
      }
    });

    _finishAction = partnerEndCallback;

    methodChannel.invokeMethod<void>('start', <String, dynamic>{
      'verifToken': verificationToken,
      'verifScheme': verificationScheme.name.toLowerCase(),
      'languageCode': languageCode,
      'environment': environment?.name.toLowerCase() ?? "dev",
      'showPartnerLogo': showPartnerLogo ?? false,
      'showCloseSDKButton': showCloseSDKButton ?? true,
      'colorBackgroundTertiary': colorBackgroundTertiary,
      'colorBackgroundSecondary': colorBackgroundSecondary,
      'colorBackgroundPrimary': colorBackgroundPrimary,
      'colorTextSecondary': colorTextSecondary,
      'colorTextPrimary': colorTextPrimary,
      'colorBorders': colorBorders,
      'colorActionButtons': colorActionButtons,
      'colorIcons': colorIcons
    });
  }
}
