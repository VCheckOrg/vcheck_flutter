import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:vcheck_flutter/vcheck_flutter.dart';
import 'vcheck_flutter_platform_interface.dart';

const methodChannel = MethodChannel("com.vcheck.vcheck_flutter");

const onFinishMethodName = "onFinish";
const onExpiredMethodName = "onExpired";

/// An implementation of [VcheckFlutterPlatform] that uses method channels.
class MethodChannelVcheckFlutter extends VcheckFlutterPlatform {
  /// The method channel used to interact with the native platform.

  Function? _finishAction;
  Function? _expiredAction;

  @override
  void start(
      {required String verificationToken,
      required VerificationSchemeType verificationScheme,
      required String languageCode,
      required Function partnerEndCallback,
      required Function onVerificationExpired,
      required VCheckEnvironment environment,
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
        case onFinishMethodName:
          Future.delayed(const Duration(milliseconds: 500), () {
            _finishAction!();
          });
          return;
        case onExpiredMethodName:
          Future.delayed(const Duration(milliseconds: 500), () {
            _expiredAction!();
          });
          return;
        default:
          throw MissingPluginException('Not Implemented');
      }
    });

    _finishAction = partnerEndCallback;

    _expiredAction = onVerificationExpired;

    methodChannel.invokeMethod<void>('start', <String, dynamic>{
      'verifToken': verificationToken,
      'verifScheme': verificationScheme.name.toLowerCase(),
      'languageCode': languageCode,
      'environment': environment.name.toLowerCase(),
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
