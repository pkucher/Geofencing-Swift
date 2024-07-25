import UIKit
import GoogleMaps
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let googleMapsAPIKey = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(googleMapsAPIKey)

        // Configura o LocationManager
        LocationManager.shared.requestLocationAuthorization()
        
        // Configura a tela inicial
        let navigationController = UINavigationController(rootViewController: AddressViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Inicia o monitoramento de localização significativa
        LocationManager.shared.startMonitoringSignificantLocationChanges()
    }
}

