import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vcheck_flutter/vcheck_flutter.dart';

import 'vcheck_flutter_method_channel.dart';

abstract class VcheckFlutterPlatform extends PlatformInterface {
  /// Constructs a VcheckFlutterTestPlatform.
  VcheckFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static VcheckFlutterPlatform _instance = MethodChannelVcheckFlutter();

  /// The default instance of [VcheckFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelVcheckFlutter].
  static VcheckFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VcheckFlutterPlatform] when
  /// they register themselves.
  static set instance(VcheckFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
      String? colorIcons}) {
    throw UnimplementedError('start() has not been implemented.');
  }
}
