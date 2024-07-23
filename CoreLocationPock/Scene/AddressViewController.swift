//  AddressViewController.swift
//  CoreLocationPock
//
//  Created by user on 22/02/24.
//

import UIKit
import CoreLocation

class AddressViewController: UIViewController {
    
    var cepTextField = UITextField()
    var addressStreetTextField = UITextField()
    var addressNumberTextField = UITextField()
    var radiusNumberTextField = UITextField()
    var button = UIButton()
    var currentLocationButton = UIButton()
    var addressResultLabel = UILabel()
    var viewModel = MapViewModel()
    var locationManager = CLLocationManager()
    var activityIndicator: UIActivityIndicatorView?
    var loadingOverlay: UIView?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupUI()
        constrainUI()
        setupGesture()
    }
    
    func setupUI() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .lightGray
        cepTextField.placeholder = "Digite o Cep"
        cepTextField.borderStyle = .roundedRect
        cepTextField.delegate = self
        cepTextField.keyboardType = .decimalPad
        
        addressStreetTextField.placeholder = "Digite o endereço"
        addressStreetTextField.borderStyle = .roundedRect
        addressStreetTextField.delegate = self
        
        addressNumberTextField.placeholder = "Digite o Numero do endereço"
        addressNumberTextField.borderStyle = .roundedRect
        addressNumberTextField.delegate = self
        addressNumberTextField.keyboardType = .decimalPad
        
        radiusNumberTextField.placeholder = "Digite quantos metros o raio de distancia terá"
        radiusNumberTextField.borderStyle = .roundedRect
        radiusNumberTextField.delegate = self
        radiusNumberTextField.keyboardType = .decimalPad
        
        button.setTitle("Buscar endereço", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        currentLocationButton.setTitle("Usar localização atual", for: .normal)
        currentLocationButton.setTitleColor(.black, for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 8
        currentLocationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        
        addressResultLabel.numberOfLines = 3
        setupLocationManager()
        setupLoadingOverlay()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }
    
    
    func setupLoadingOverlay() {
        loadingOverlay = UIView(frame: view.bounds)
        loadingOverlay?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingOverlay?.isHidden = true // Começa oculta
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .red
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        if let loadingOverlay = loadingOverlay, let activityIndicator = activityIndicator {
            view.addSubview(loadingOverlay)
            loadingOverlay.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
            ])
        }
    }
    
    func constrainUI() {
        view.addSubview(cepTextField)
        view.addSubview(addressStreetTextField)
        view.addSubview(addressNumberTextField)
        view.addSubview(radiusNumberTextField)
        view.addSubview(addressResultLabel)
        view.addSubview(button)
        view.addSubview(currentLocationButton)
        
        cepTextField.translatesAutoresizingMaskIntoConstraints = false
        cepTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        cepTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        cepTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cepTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addressStreetTextField.translatesAutoresizingMaskIntoConstraints = false
        addressStreetTextField.topAnchor.constraint(equalTo: cepTextField.bottomAnchor, constant: 40).isActive = true
        addressStreetTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addressStreetTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addressStreetTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addressNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        addressNumberTextField.topAnchor.constraint(equalTo: addressStreetTextField.bottomAnchor, constant: 40).isActive = true
        addressNumberTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addressNumberTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        addressNumberTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        radiusNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        radiusNumberTextField.topAnchor.constraint(equalTo: addressNumberTextField.bottomAnchor, constant: 40).isActive = true
        radiusNumberTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        radiusNumberTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        radiusNumberTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addressResultLabel.translatesAutoresizingMaskIntoConstraints = false
        addressResultLabel.topAnchor.constraint(equalTo: radiusNumberTextField.bottomAnchor, constant: 20).isActive = true
        addressResultLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addressResultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        button.bottomAnchor.constraint(equalTo: currentLocationButton.topAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        currentLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        currentLocationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func formattedNumber(replacementString: String) -> String {
        guard let text = cepTextField.text else { return "" }
        if text.count == 5, replacementString != "" {
            return text + "-"
        }
        return text
    }
    
    func showLoading() {
        loadingOverlay?.isHidden = false
        activityIndicator?.startAnimating()
        view.bringSubviewToFront(loadingOverlay!)
    }
    
    func hideLoading() {
        loadingOverlay?.isHidden = true
        activityIndicator?.stopAnimating()
    }
    
    @objc func getCurrentLocation(){
        guard let currentLocation = locationManager.location?.coordinate else { return }
        
        viewModel.coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude:  currentLocation.longitude)
        guard let radiusString = radiusNumberTextField.text,
              let radius = Int(radiusString) else {
            self.addressResultLabel.text = "Por favor inserir o raio"
            return
        }
        viewModel.raidusMeterDistance = radius
        navigationController?.pushViewController(MapViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func buttonAction() {
        showLoading()
        guard let radiusString = radiusNumberTextField.text,
              let radius = Int(radiusString) else {
            self.addressResultLabel.text = "Por favor inserir o raio"
            DispatchQueue.main.async {
                self.hideLoading()
            }
            return
        }
        var text = ""
        if let cepText = cepTextField.text, !cepText.isEmpty {
            text = "\(extractNumbers(cepText))"
        }
        if let addressText = addressStreetTextField.text, !addressText.isEmpty {
            text = "\(text)+\(addressText)"
        }
        if let numberText = addressNumberTextField.text, !numberText.isEmpty {
            text = "\(text)+\(numberText)"
        }
        guard !text.isEmpty else {
            DispatchQueue.main.async {
                self.hideLoading()
            }
            return
        }
        viewModel.getData(address: text) {[weak self] in
            guard let self = self,
                  let addressData = self.viewModel.addressData?.first else {
                self?.addressResultLabel.text = "Por favor digite um endereço valido"
                DispatchQueue.main.async {
                    self?.hideLoading()
                }
                return
            }
            for component in addressData.addressComponents {
                if component.types.contains(where: {$0 == "route"}) {
                    self.addressStreetTextField.text =  component.longName
                }
                
                if component.types.contains(where: {$0 == "postal_code"}) {
                    self.cepTextField.text = component.longName
                }
            }
            DispatchQueue.main.async {
                self.hideLoading()
            }
            addressResultLabel.text = addressData.formattedAddress
            if !viewModel.hasError,
               viewModel.addressData != nil {
                viewModel.raidusMeterDistance = radius
                self.addressResultLabel.text = ""
                navigationController?.pushViewController(MapViewController(viewModel: viewModel), animated: true)
            }
        }
    }
    
    func extractNumbers(_ input: String) -> String {
        let numbers = input.filter { $0.isNumber }
        return String(numbers)
    }
}

extension AddressViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        if textField == radiusNumberTextField {
            return range.location < 4
        }
        if textField == cepTextField {
            let allowedCharacters = "0123456789"
            if !allowedCharacters.contains(string) {
                return false
            }
            textField.text = formattedNumber(replacementString: string)
            return range.location < 9
        }
        return true
    }
}

extension AddressViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("Não determinado")
        case .restricted:
            print("Restrito")
        case .denied:
            print("Negado")
        case .authorizedAlways:
            print("Pronto")
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        default:
            print("Nada")
        }
    }
}
