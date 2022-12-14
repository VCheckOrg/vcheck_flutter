import 'vcheck_flutter_platform_interface.dart';

//** -------------- Upper-level SDK class

class VCheckSDK {
  VCheckSDK._privateConstructor();

  static final VCheckSDK instance = VCheckSDK._privateConstructor();

  static void start(
      {required String verificationToken,
      required VerificationSchemeType verificationScheme,
      required String languageCode,
      required Function partnerEndCallback,
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
    VcheckFlutterPlatform.instance.start(
        verificationToken: verificationToken,
        verificationScheme: verificationScheme,
        languageCode: languageCode,
        environment: environment,
        partnerEndCallback: partnerEndCallback,
        showCloseSDKButton: showCloseSDKButton,
        showPartnerLogo: showPartnerLogo,
        colorActionButtons: colorActionButtons,
        colorBackgroundPrimary: colorBackgroundPrimary,
        colorBackgroundSecondary: colorBackgroundSecondary,
        colorBackgroundTertiary: colorBackgroundTertiary,
        colorBorders: colorBorders,
        colorTextPrimary: colorTextPrimary,
        colorTextSecondary: colorTextSecondary,
        colorIcons: colorIcons);
  }
}

//** -------------- Domain models

class FinalVerificationStatus {
  bool? _isFinalizedAndSuccessful;
  bool? _isFinalizedAndFailed;
  bool? _isWaitingForManualCheck;
  String? _status;
  String? _scheme;
  String? _createdAt;
  String? _finalizedAt;
  List<String>? _rejectionReasons;

  FinalVerificationStatus(
      {bool? isFinalizedAndSuccessful,
      bool? isFinalizedAndFailed,
      bool? isWaitingForManualCheck,
      String? status,
      String? scheme,
      String? createdAt,
      String? finalizedAt,
      List<String>? rejectionReasons}) {
    if (isFinalizedAndSuccessful != null) {
      _isFinalizedAndSuccessful = isFinalizedAndSuccessful;
    }
    if (isFinalizedAndFailed != null) {
      _isFinalizedAndFailed = isFinalizedAndFailed;
    }
    if (isWaitingForManualCheck != null) {
      _isWaitingForManualCheck = isWaitingForManualCheck;
    }
    if (status != null) {
      _status = status;
    }
    if (scheme != null) {
      _scheme = scheme;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (finalizedAt != null) {
      _finalizedAt = finalizedAt;
    }
    if (rejectionReasons != null) {
      _rejectionReasons = rejectionReasons;
    }
  }

  bool? get isFinalizedAndSuccessful => _isFinalizedAndSuccessful;
  set isFinalizedAndSuccessful(bool? isFinalizedAndSuccessful) =>
      _isFinalizedAndSuccessful = isFinalizedAndSuccessful;
  bool? get isFinalizedAndFailed => _isFinalizedAndFailed;
  set isFinalizedAndFailed(bool? isFinalizedAndFailed) =>
      _isFinalizedAndFailed = isFinalizedAndFailed;
  bool? get isWaitingForManualCheck => _isWaitingForManualCheck;
  set isWaitingForManualCheck(bool? isWaitingForManualCheck) =>
      _isWaitingForManualCheck = isWaitingForManualCheck;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get scheme => _scheme;
  set scheme(String? scheme) => _scheme = scheme;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get finalizedAt => _finalizedAt;
  set finalizedAt(String? finalizedAt) => _finalizedAt = finalizedAt;
  List<String>? get rejectionReasons => _rejectionReasons;
  set rejectionReasons(List<String>? rejectionReasons) =>
      _rejectionReasons = rejectionReasons;

  FinalVerificationStatus.fromJson(Map<String, dynamic> json) {
    _isFinalizedAndSuccessful = json['isFinalizedAndSuccessful'];
    _isFinalizedAndFailed = json['isFinalizedAndFailed'];
    _isWaitingForManualCheck = json['isWaitingForManualCheck'];
    _status = json['status'];
    _scheme = json['scheme'];
    _createdAt = json['createdAt'];
    _finalizedAt = json['finalizedAt'];
    _rejectionReasons = json['rejectionReasons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isFinalizedAndSuccessful'] = _isFinalizedAndSuccessful;
    data['isFinalizedAndFailed'] = _isFinalizedAndFailed;
    data['isWaitingForManualCheck'] = _isWaitingForManualCheck;
    data['status'] = _status;
    data['scheme'] = _scheme;
    data['createdAt'] = _createdAt;
    data['finalizedAt'] = _finalizedAt;
    data['rejectionReasons'] = _rejectionReasons;
    return data;
  }
}

enum VerificationSchemeType {
  FULL_CHECK, // = ??full_check??
  DOCUMENT_UPLOAD_ONLY, // = ??document_upload_only??
  LIVENESS_CHALLENGE_ONLY // = ??liveness_challenge_only??
}

enum VCheckEnvironment { DEV, PARTNER }
