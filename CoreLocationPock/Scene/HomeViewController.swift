import UIKit
import CoreLocation

//Faz o pedido de permissao do uso da localização e fica observando se a localização esta a 100m do local informado em uma area circular
class HomeViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupLocationManager()
        view.backgroundColor = .white
    }
    
    //Inicializando o LocationManager e verificando as permissoes do app
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
    }
    
    func setupGeofencing(){
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self),
              locationManager?.authorizationStatus == .authorizedAlways else {
            showAlert(message: "Geofencing nao esta habilitado nesse device")
            return
        }
        startMonitoring()
    }
    
    func startMonitoring() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.3346438, longitude: -122.008972)
        let geofenceRegion = CLCircularRegion(center: coordinate, radius: 100, identifier: "apple-park")
        
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        locationManager?.startMonitoring(for: geofenceRegion)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}


extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Não determinado")
        case .restricted:
            print("Restrito")
        case .denied:
            print("Negado")
        case .authorizedAlways:
            setupGeofencing()
        case .authorizedWhenInUse:
            locationManager?.requestAlwaysAuthorization()
        default:
            print("Nada")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        view.backgroundColor = .red
        showAlert(message: "Usuario entrando \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        view.backgroundColor = .white
        showAlert(message: "Usuario saindo \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Falha em monitorar esta região")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter a localização: \(error.localizedDescription)")
    }
}
