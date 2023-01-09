# VCheck for Flutter

[VCheck](https://vycheck.com/) is online remote verification service for fast and secure customer access to your services.

This package represents VCheck SDK for Flutter(iOS, Android).
The native plugins in the package itself use dependencies of [Android](https://jitpack.io/#VCheckOrg/vcheck_android) and [iOS](https://cocoapods.org/pods/VCheckSDK) SDKs channeled to Flutter SDK.

## Features

- Document validity: Country and document type identification. Checks for forgery and interference (glare, covers, third-party objects)
- Document data recognition: The data of the loaded document is automatically parsed
- Liveliness check: Determining that a real person is being verified
- Face matching: Validate that the document owner is the user being verified
- Easy integration to your service's Flutter app out-of-the-box

## How to use
#### Add dependency 

```
vcheck_flutter: ^1.0.34
```

#### Start SDK flow

```
import 'package:vcheck_flutter_test/vcheck_flutter.dart';

//...

VCheckSDK.start(
        verificationToken: verifToken,
        verificationScheme: verifScheme,
        languageCode: "en",
        environment: VCheckEnvironment.DEV,
        partnerEndCallback: partnerEndCallback());
```


#### Explication for required properties

| Property | Type | Description |
| ----------- | ----------- | ----------- |
| verificationToken | String | Valid token of recently created VCheck Verification |
| verificationScheme | VerificationSchemeType | Verification scheme type |
| languageCode | String | 2-letter language code (Ex.: "en" ; implementation's default is "en") |
| environment | VCheckEnvironment | VCheck service environment (dev/partner) |
| partnerEndCallback | Function | Callback function which triggers on verification process and SDK flow finish |


#### Optional properties for verification session's logic and UI customization

| Property | Type | Description |
| ----------- | ----------- | ----------- |
| colorBackgroundPrimary | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorBackgroundSecondary | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorBackgroundTertiary | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorActionButtons | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorTextPrimary | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorTextSecondary | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorBorders | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| colorIcons | String? | HEX string (ex.: '#2A2A2A' or '#abdbe3') |
| showCloseSDKButton | bool? | Should 'Return to Partner' button be shown |
| showPartnerLogo | bool? | Should Partner logo be shown |
