import Foundation
import CoreLocation

protocol BeaconManagerDelegate: class {
    func closestBeaconDidChange(beacon: CLBeacon?)
}

class BeaconManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private let uuid = UUID(uuidString: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")!

    weak var delegate: BeaconManagerDelegate?
    
    func startMonitoring() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: "UL")
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        delegate?.closestBeaconDidChange(beacon: beacons.first)
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("Failed ranging")
    }
}
