import Flutter
import UIKit

public class LauncherIconSwitcherPlugin: NSObject, FlutterPlugin {
    private static let noIconsError =
    FlutterError(code: "NO_ICONS",message: "No icons were provided", details: nil)
    private static let notInitializedError =
    FlutterError(code: "NOT_INITIALIZED", message:"Plugin was not initialized properly", details: nil)
    private var icons: [String] = []
    private var defaultIcon: String = ""
    private var isInitialized = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "launcher_icon_switcher", binaryMessenger: registrar.messenger())
        let instance = LauncherIconSwitcherPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            let args = call.arguments as! NSDictionary
            icons = args["icons"] as! [String]
            defaultIcon = args["defaultIcon"] as! String
            
            if(icons.isEmpty){
                result(LauncherIconSwitcherPlugin.noIconsError)
                return
            }
            
            isInitialized = true
            result(nil)
        case "getCurrentIcon":
            if(!isInitialized){
                result(LauncherIconSwitcherPlugin.notInitializedError)
                return
            }
            
            result(UIApplication.shared.alternateIconName ?? defaultIcon)
        case "setIcon":
            if(!isInitialized){
                result(LauncherIconSwitcherPlugin.notInitializedError)
                return
            }
            
            let args = call.arguments as! NSDictionary
            let targetIcon = args["icon"] as! String
            
            UIApplication.shared.setAlternateIconName(targetIcon == defaultIcon ? nil : targetIcon)
            
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
