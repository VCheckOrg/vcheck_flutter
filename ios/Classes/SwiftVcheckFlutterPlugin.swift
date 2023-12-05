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

    private var designConfig: VCheckDesignConfig? = nil
    
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

        setDesignConfig(designConfigStr: arguments["designConfigStr"] as? String)

        if let vs = self.verifScheme {
            print("VCheck_Flutter_iOS : Using \(String(describing: vs.description.uppercased())) verification scheme")
        }
        if let env = self.environment {
            print("VCheck_Flutter_iOS : Using \(String(describing: env.description.uppercased())) environment")
        }
        if (environment == VCheckEnvironment.DEV) {
            print("VCheck_Flutter_iOS : Warning - SDK environment is not set or default; using DEV environment by default")
        }

        result("VCheck_Flutter_iOS : iOS SDK start() method called")
        
        self.launchSDK()
    }

    private func launchSDK() {
                
        VCheckSDK.shared
            .verificationToken(token: self.verificationToken!)
            .verificationType(type: self.verifScheme!)
            .languageCode(langCode: self.languageCode!)
            .environment(env: self.environment!)
            .showPartnerLogo(show: self.showPartnerLogo!)
            .showCloseSDKButton(show: self.showCloseSDKButton!)
            .designConfig(config: self.designConfig)
            .partnerEndCallback(callback: {
                self.onVCheckSDKFlowFinish()
            })
            .onVerificationExpired(callback: {
                self.onVerificationExpired()
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

    private func onVerificationExpired() {
        DispatchQueue.main.async {
            self.channel!.invokeMethod("onExpired", arguments: nil, result: {(r:Any?) -> () in
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
        //print("applicationDidBecomeActive")
        self.application = application
    }

    private func setDesignConfig(designConfigStr: String?) {
        if let possibleJsonData = designConfigStr {
                
            if (!possibleJsonData.isEmpty) {
                if let value = try? JSONDecoder()
                    .decode(VCheckDesignConfig.self, from: possibleJsonData.data(using: .utf8)!) {
                    self.designConfig = value
                } else {
                    print("Non-valid JSON was passed while initializing "
                              + "VCheckDesignConfig instance. Persisting VCheck default theme")
                    self.designConfig = VCheckDesignConfig.getDefaultThemeConfig()
                }
            } else {
                print("No JSON data was passed while initializing "
                          + "VCheckDesignConfig instance. Persisting VCheck default theme")
            }
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
        //Stub
        //print("applicationWillTerminate")
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        //Stub
        //print("applicationWillResignActive")
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        //Stub
        //print("applicationDidEnterBackground")
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        //Stub
        //print("applicationWillEnterForeground")
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
