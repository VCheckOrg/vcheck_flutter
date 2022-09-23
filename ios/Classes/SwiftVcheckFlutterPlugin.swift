import Flutter
import UIKit
import VCheckSDK

public class SwiftVcheckFlutterPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate {

    private var application: UIApplication? = nil

    private var verificationToken: String? = nil
    
    private var verifScheme: VerificationSchemeType? = nil

    private var environment: VCheckEnvironment? = nil

    private var languageCode: String? = nil
    
    private var showPartnerLogo: Bool? = false
    private var showCloseSDKButton: Bool? = true

    private var colorBackgroundTertiary: String? = nil
    private var colorBackgroundSecondary: String? = nil
    private var colorBackgroundPrimary: String? = nil
    private var colorTextSecondary: String? = nil
    private var colorTextPrimary: String? = nil
    private var colorBorders: String? = nil
    private var colorActionButtons: String? = nil
    private var colorIcons: String? = nil
    
    private var channel: FlutterMethodChannel? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.vcheck.vcheck_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftVcheckFlutterPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if (call.method == "start") {
            self.startSDKFlow(call, result: result);
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startSDKFlow(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        let arguments = call.arguments as! [String: Any]
        
        self.verificationToken = arguments["verifToken"] as? String
        
        self.verifScheme = convertStrToVerifScheme(str: (arguments["verifScheme"] as? String)?.lowercased())

        self.environment = convertStrToEnvironment(str: (arguments["environment"] as? String)?.lowercased())

        self.languageCode = arguments["languageCode"] as? String
        
        self.showPartnerLogo = arguments["showPartnerLogo"] as? Bool
        self.showCloseSDKButton = arguments["showCloseSDKButton"] as? Bool

        self.colorBackgroundTertiary = arguments["colorBackgroundTertiary"] as? String
        self.colorBackgroundSecondary = arguments["colorBackgroundSecondary"] as? String
        self.colorBackgroundPrimary = arguments["colorBackgroundPrimary"] as? String
        self.colorTextSecondary = arguments["colorTextSecondary"] as? String
        self.colorTextPrimary = arguments["colorTextPrimary"] as? String
        self.colorBorders = arguments["colorBorders"] as? String
        self.colorActionButtons = arguments["colorActionButtons"] as? String
        self.colorIcons = arguments["colorIcons"] as? String

        if let vs = self.verifScheme {
            print("VCheck_Flutter_iOS : Using \(String(describing: vs.description.uppercased())) verification scheme")
        }
        if let env = self.environment {
            print("VCheck_Flutter_iOS : Using \(String(describing: env.description.uppercased())) environment")
        }
        if (environment == VCheckEnvironment.DEV) {
            print("VCheck_Flutter_iOS - Warning: SDK environment is not set or default; using DEV environment by default")
        }

        result("VCheck_Flutter_iOS : iOS SDK start() method called")
        
        self.launchSDK()
    }

    private func launchSDK() {
        
        self.setColorsIfPresent()
        
        VCheckSDK.shared
            .verificationToken(token: self.verificationToken!)
            .verificationType(type: self.verifScheme!)
            .languageCode(langCode: self.languageCode!)
            .environment(env: self.environment!)
            .showPartnerLogo(show: self.showPartnerLogo!)
            .showCloseSDKButton(show: self.showCloseSDKButton!)
            .partnerEndCallback(callback: {
                self.onVCheckSDKFlowFinish()
            })
            .start(partnerAppRW: getOwnRootWindow()!,
                    partnerAppVC: (UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController)!,
                    replaceRootVC: false)
    }
    
    private func onVCheckSDKFlowFinish() {
        
        DispatchQueue.main.async {
            self.channel!.invokeMethod("onFinish", arguments: nil, result: {(r:Any?) -> () in
                print(r.debugDescription);
            })
        }
    }
    
    private func getOwnRootWindow() -> UIWindow? {
        if let window = UIApplication.shared.currentWindow {
            return window
        } else {
            return nil
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("applicationDidBecomeActive")
        self.application = application
    }
    
    private func setColorsIfPresent() {
       if let it = colorActionButtons {
           VCheckSDK.shared.colorActionButtons(colorHex: it)
       }
       if let it = colorBorders {
         VCheckSDK.shared.colorBorders(colorHex: it)
       }
       if let it = colorTextPrimary {
         VCheckSDK.shared.colorTextPrimary(colorHex: it)
       }
       if let it = colorTextSecondary {
         VCheckSDK.shared.colorTextSecondary(colorHex: it)
       }
       if let it = colorBackgroundPrimary {
         VCheckSDK.shared.colorBackgroundPrimary(colorHex: it)
       }
       if let it =  colorBackgroundSecondary {
         VCheckSDK.shared.colorBackgroundSecondary(colorHex: it)
       }
       if let it = colorBackgroundTertiary {
         VCheckSDK.shared.colorBackgroundTertiary(colorHex: it)
       }
        if let it = colorIcons {
            VCheckSDK.shared.colorIcons(colorHex: it)
        }
    }
    
    private func convertStrToVerifScheme(str: String?) -> VerificationSchemeType? {
        let list = [
            VerificationSchemeType.FULL_CHECK,
            VerificationSchemeType.LIVENESS_CHALLENGE_ONLY,
            VerificationSchemeType.DOCUMENT_UPLOAD_ONLY
        ]
        return list.first { $0.description.lowercased() == str }
    }

    private func convertStrToEnvironment(str: String?) -> VCheckEnvironment? {
        let list = [
            VCheckEnvironment.DEV,
            VCheckEnvironment.PARTNER
        ]
        return list.first { $0.description.lowercased() == str }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("applicationWillTerminate")
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        debugPrint("applicationWillResignActive")
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("applicationDidEnterBackground")
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
}

extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
