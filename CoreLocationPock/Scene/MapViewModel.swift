//
//  MapViewModel.swift
//  CoreLocationPock
//
//  Created by user on 21/02/24.
//

import Foundation
import CoreLocation

class MapViewModel {
    var addressData: [AdressData]?
    var isLoading = false
    var hasError = false
    var coordinate: CLLocationCoordinate2D?
    var raidusMeterDistance = 100

    func getData(address: String, completion: @escaping () -> Void) {
        MapService().getAddressData(address: address) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let address):
                guard let addressDataResult = address?.results else { return }
                if let status = address?.status,
                   status != "INVALID_REQUEST" {
                    DispatchQueue.main.async {
                        self.addressData = addressDataResult
                        self.isLoading = false
                        self.hasError = false
                        if let latitude = addressDataResult.first?.geometry.location.lat,
                           let longitude = addressDataResult.first?.geometry.location.lng {
                            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude:  longitude)
                        }
                        completion()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.addressData =  nil
                        self.hasError = true
                        completion()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.addressData =  nil
                    self.hasError = true
                    completion()
                }
            }
        }
    }
}
