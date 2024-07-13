//
//  MapViewController.swift
//  CoreLocationPock
//
//  Created by user on 19/02/24.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var mapView = MKMapView()
    var viewModel: MapViewModel?
    
    init(viewModel: MapViewModel = MapViewModel()) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupLocationManager()
        setupMapAndCircle()
        constraintUI()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true
        
        locationManager?.requestAlwaysAuthorization()
    }
    
    func setupMapAndCircle() {
        mapView.delegate = self
        guard let coordinate = viewModel?.coordinate else { return }
        mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.overrideUserInterfaceStyle = .dark
        let circle = MKCircle(center: coordinate, radius: CLLocationDistance(viewModel!.raidusMeterDistance))
        mapView.addOverlay(circle)
    }
    
    func constraintUI(){
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
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
        guard let coordinate = viewModel?.coordinate else { return }
        let geofenceRegion = CLCircularRegion(center: coordinate, radius: CLLocationDistance(viewModel!.raidusMeterDistance), identifier: "destino")
        
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


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.strokeColor = .red
            circleRenderer.alpha = 0.5
        }
        return circleRenderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
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
        showAlert(message: "Usuario entrando no \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        view.backgroundColor = .white
        showAlert(message: "Usuario saindo do \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Falha em monitorar esta região")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter a localização: \(error.localizedDescription)")
    }
}
