//
//  AddressViewController.swift
//  CoreLocationPock
//
//  Created by user on 22/02/24.
//

import UIKit

class AddressViewController: UIViewController {
    
    var cepTextField = UITextField()
    var addressStreetTextField = UITextField()
    var addressNumberTextField = UITextField()
    var button = UIButton()
    var addressResultLabel = UILabel()
    var viewModel = MapViewModel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupUI()
        constrainUI()
    }
    
    func setupUI() {
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
        
        button.setTitle("Buscar Endereço", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addressResultLabel.numberOfLines = 3
    }
    
    func constrainUI() {
        view.addSubview(cepTextField)
        view.addSubview(addressStreetTextField)
        view.addSubview(addressNumberTextField)
        view.addSubview(button)
        view.addSubview(addressResultLabel)
        
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
        
        addressResultLabel.translatesAutoresizingMaskIntoConstraints = false
        addressResultLabel.topAnchor.constraint(equalTo: addressNumberTextField.bottomAnchor, constant: 20).isActive = true
        addressResultLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addressResultLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true

    }
    
    func formattedNumber(replacementString: String) -> String {
        guard let text = cepTextField.text else { return "" }
        if text.count == 5 ,
           replacementString != ""{
            return text + "-"
        }
        return text
    }
    
    @objc func buttonAction() {
        guard let text = cepTextField.text else { return }
        viewModel.getData(address: text) {[weak self] in
            guard let self = self,
            let addressData = self.viewModel.addressData?.first else { 
                self?.addressResultLabel.text = "Erro na requisição"
                return
            }
            addressResultLabel.text = addressData.formattedAddress
            if !viewModel.hasError,
               viewModel.addressData != nil {
                navigationController?.pushViewController(MapViewController(viewModel: viewModel), animated: true)
            }
        }
    }
}


extension AddressViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:  String) -> Bool {
        if string.isEmpty{ return true }
        if textField != addressStreetTextField {
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


extension AddressViewController: UI
