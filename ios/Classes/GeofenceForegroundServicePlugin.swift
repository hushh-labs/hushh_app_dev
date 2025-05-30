import Flutter
import UIKit
import CoreLocation

public class GeofenceForegroundServicePlugin: NSObject, FlutterPlugin {
    static let identifier = "ps.byshy.geofence"

    private static var flutterPluginRegistrantCallback: FlutterPluginRegistrantCallback?

    @objc
    public static func setPluginRegistrantCallback(_ callback: @escaping FlutterPluginRegistrantCallback) {
        flutterPluginRegistrantCallback = callback
    }

    private var locationManager = CLLocationManager()
    private var result: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = GeofenceForegroundServicePlugin()

        instance.locationManager.delegate = instance

        instance.locationManager.requestAlwaysAuthorization()

        instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        instance.locationManager.distanceFilter = 1.0

        let channel = FlutterMethodChannel(
            name: "\(GeofenceForegroundServicePlugin.identifier)/foreground_geofence_foreground_service",
            binaryMessenger: registrar.messenger()
        )

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result

        switch call.method {
        case "startGeofencingService":
            guard
                let arguments = call.arguments as? [AnyHashable: Any],
                let isInDebug = arguments["isInDebugMode"] as? Bool,
                let handle = arguments["callbackHandle"] as? Int64
            else {
                result(FlutterError(code: "INVALID_PARAMETERS", message: "Invalid parameters", details: nil))
                return
            }

            // Store callback handle and debug mode
            UserDefaults.standard.set(handle, forKey: "callbackHandle")
            UserDefaults.standard.set(isInDebug, forKey: "isInDebugMode")

            // Check if we have proper authorization before enabling background updates
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                // Only enable background updates if we have proper authorization
                if #available(iOS 9.0, *) {
                    locationManager.allowsBackgroundLocationUpdates = true
                }
                locationManager.pausesLocationUpdatesAutomatically = false
                locationManager.startUpdatingLocation()
                result(true)
            } else {
                // Request authorization first
                locationManager.requestAlwaysAuthorization()
                result(false)
            }
            
        case "stopGeofencingService":
            if #available(iOS 9.0, *) {
                locationManager.allowsBackgroundLocationUpdates = false
            }
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.stopUpdatingLocation()

            result(true)
        case "isForegroundServiceRunning":
            if #available(iOS 9.0, *) {
                result(locationManager.allowsBackgroundLocationUpdates)
            } else {
                result(false)
            }
        case "addGeofence":
            guard let arguments = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_PARAMETERS", message: "Invalid parameters", details: nil))
                return
            }
            
            let jsonData = try! JSONSerialization.data(withJSONObject: arguments, options: [])

            do {
                let zone = try JSONDecoder().decode(Zone.self, from: jsonData)
                addGeoFence(zone: zone, result: result)
            } catch {
                print("Error decoding Zone: \(error)")
                result(FlutterError(code: "DECODE_ERROR", message: "Error decoding zone", details: error.localizedDescription))
            }
        case "addGeoFences":
            result(false)
        case "removeGeofence":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func addGeoFence(zone: Zone, result: @escaping FlutterResult) {
        guard let coordinates = zone.coordinates, !coordinates.isEmpty else {
            result(
                FlutterError(
                    code: "INVALID_COORDINATES",
                    message: "Zone coordinates are invalid",
                    details: nil
                )
            )
            return
        }

        let firstCoordinate = coordinates[0]

        let geofenceRegion = CLCircularRegion(
            center: firstCoordinate.asCLLocationCoordinate2D,
            radius: zone.radius,
            identifier: zone.id
        )

        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true

        locationManager.startMonitoring(for: geofenceRegion)
        
        result(true)
    }
}

extension GeofenceForegroundServicePlugin: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            // Now we can safely enable background location updates
            if #available(iOS 9.0, *) {
                locationManager.allowsBackgroundLocationUpdates = true
            }
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            // Only foreground location access
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates here
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered geofence: \(region.identifier)")
        eventHandler(zoneID: region.identifier, triggerType: 1)
    }

    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited geofence: \(region.identifier)")
        eventHandler(zoneID: region.identifier, triggerType: 2)
    }

    public func eventHandler(zoneID: String, triggerType: Int) {
        guard
            let callbackHandle = UserDefaults.standard.object(forKey: "callbackHandle") as? Int64,
            let _ = FlutterCallbackCache.lookupCallbackInformation(callbackHandle)
        else {
            print("Plugin not initialized or callback not found")
            return
        }

        // Handle the geofence event
        print("Geofence event: Zone \(zoneID), Trigger: \(triggerType)")
    }
}

// Dummy structs for compilation - these should match the actual plugin models
struct Zone: Codable {
    let id: String
    let coordinates: [Coordinate]?
    let radius: Double
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
