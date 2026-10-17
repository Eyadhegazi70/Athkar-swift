import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var qiblaBearing: Double = 0.0

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        calculateQibla(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }

    private func calculateQibla(lat: Double, lon: Double) {
        // إحداثيات الكعبة المشرفة بدقة
        let kaabaLat = 21.4225 * .pi / 180.0
        let kaabaLon = 39.8262 * .pi / 180.0
        let userLat = lat * .pi / 180.0
        let userLon = lon * .pi / 180.0

        let dLon = kaabaLon - userLon
        let y = sin(dLon) * cos(kaabaLat)
        let x = cos(userLat) * sin(kaabaLat) - sin(userLat) * cos(kaabaLat) * cos(dLon)
        var radians = atan2(y, x)
        if radians < 0 { radians += 2 * .pi }
        
        DispatchQueue.main.async {
            self.qiblaBearing = radians * 180.0 / .pi
        }
    }
}