//
//  ViewController.swift
//  CoreLocationPock
//
//  Created by user on 19/02/24.
//

import UIKit
import CoreLocation


//Somente faz o pedido de permissao do uso da localização
class ViewController: UIViewController {

    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Falha em monitorar esta região")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter a localização: \(error.localizedDescription)")
    }
}
