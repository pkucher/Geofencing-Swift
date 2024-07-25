import UIKit
import CoreLocation
import MapKit
import UserNotifications

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var mapView = MKMapView()
    var viewModel: MapViewModel?
    
    init(viewModel: MapViewModel = MapViewModel()) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupMapAndCircle()
        constraintUI()
        schedule()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func setupMapAndCircle() {
        mapView.delegate = self
        guard let coordinate = viewModel?.coordinate else { return }
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.overrideUserInterfaceStyle = .dark
        let circle = MKCircle(center: coordinate, radius: CLLocationDistance(viewModel!.raidusMeterDistance))
        mapView.showsUserLocation = true
        mapView.addOverlay(circle)
    }
    
    func constraintUI() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func startMonitoring() {
        guard let coordinate = viewModel?.coordinate else { return }
        let geofenceRegion = CLCircularRegion(center: coordinate, radius: CLLocationDistance(viewModel!.raidusMeterDistance), identifier: "destino")
        
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func schedule() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in
                    if didAllow {
                        print("Notificações autorizadas")
                    }
                }
            case .denied:
                print("Notificações negadas")
            case .authorized, .provisional:
                print("Notificações permitidas")
            case .ephemeral:
                print("Status de autorização desconhecido")
            default:
                print("desconhecido")
            }
        }
    }
    
    func showAlert(_ message: String) {
        let identifier = "my-morning-notification"
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "teste IOS"
        content.body = message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Erro ao adicionar notificação: \(error.localizedDescription)")
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.strokeColor = .red
            circleRenderer.alpha = 0.3
        }
        return circleRenderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Autorização de localização não determinada")
        case .restricted:
            print("Autorização de localização restrita")
        case .denied:
            print("Autorização de localização negada")
        case .authorizedAlways:
            startMonitoring()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            startMonitoring()
        default:
            print("Status de autorização desconhecido")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        showAlert("Usuario entrando no seu \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("Usuario saindo da area definida")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        manager.stopUpdatingLocation()
        showAlert("Falha em monitorar esta região: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        showAlert("Erro ao obter a localização: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        UserDefaults.standard.setValue("Latitude: \(latitude), Longitude: \(longitude)", forKey: "coordenadas")
        print("Latitude: \(latitude), Longitude: \(longitude)")
    }
}

extension MapViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
