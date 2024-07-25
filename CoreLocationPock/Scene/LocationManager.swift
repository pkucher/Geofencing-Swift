import CoreLocation
import UserNotifications

class LocationManager: NSObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var monitoredRegion: CLCircularRegion?
    
    private override init() {
        super.init()
        setupLocationManager()
        setupNotificationCenter()
    }
    
    func requestLocationAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    private func setupNotificationCenter() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notificações autorizadas")
            } else {
                print("Notificações negadas")
            }
        }
    }
    
    func startMonitoring(for coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        stopMonitoring()
        
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: "geofence")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
        monitoredRegion = region
    }
    
    func stopMonitoring() {
        if let region = monitoredRegion {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            sendLocalNotification("Entrando na região: \(circularRegion.identifier)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            sendLocalNotification("Saindo da região: \(circularRegion.identifier)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        UserDefaults.standard.setValue("Latitude: \(latitude), Longitude: \(longitude)", forKey: "coordenadas")
    }
    
    // UNUserNotificationCenterDelegate Methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // Helper method to send local notifications
    private func sendLocalNotification(_ message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Alerta de Localização"
        content.body = message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao adicionar notificação: \(error.localizedDescription)")
            }
        }
    }
}
