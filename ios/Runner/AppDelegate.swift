import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import AppTrackingTransparency
import AdSupport

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    GMSServices.provideAPIKey("AIzaSyDK5DdFAF35T1vM1NMVBlC5v3twXZ7UVk4")
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    // Set up method channel for tracking status
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.hushh.app/tracking",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      switch call.method {
      case "requestTrackingAuthorization":
        self.requestTrackingAuthorization { status in
          result(status)
        }
      case "getTrackingStatus":
        if #available(iOS 14, *) {
          let status = ATTrackingManager.trackingAuthorizationStatus
          result(self.trackingStatusToString(status))
        } else {
          result("notSupported")
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func requestTrackingAuthorization(completion: @escaping (String) -> Void) {
    if #available(iOS 14, *) {
      // Request tracking authorization after a short delay to ensure the app is fully loaded
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        ATTrackingManager.requestTrackingAuthorization { status in
          let statusString = self.trackingStatusToString(status)
          print("Tracking status: \(statusString)")
          completion(statusString)
        }
      }
    } else {
      completion("notSupported")
    }
  }
  
  @available(iOS 14, *)
  private func trackingStatusToString(_ status: ATTrackingManager.AuthorizationStatus) -> String {
    switch status {
    case .authorized:
      return "authorized"
    case .denied:
      return "denied"
    case .notDetermined:
      return "notDetermined"
    case .restricted:
      return "restricted"
    @unknown default:
      return "unknown"
    }
  }
}