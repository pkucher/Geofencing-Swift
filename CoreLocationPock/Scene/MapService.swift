//
//  MapService.swift
//  CoreLocationPock
//
//  Created by user on 21/02/24.
//

import Foundation

class MapService {
    var baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?address="
    private let key = "&key=AIzaSyA05p4CG-EAJTN8fbDmG9j-6eWH5kobt0M"
    
    
    func getAddressData(address: String, completion: @escaping (Result<AddressResultModel?, Error>) -> Void){
        let urlString = baseUrl + address + key
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let decoder = JSONDecoder()
                guard let data = data else {
                    let noDataError = NSError(domain: "Erro", code: 400, userInfo: nil)
                    completion(.failure(noDataError))
                    return
                }
                let models = try decoder.decode(AddressResultModel.self, from: data)
                completion(.success(models))
                
            }catch{
                completion(.failure(error))
            }
        })
        
        dataTask.resume()
        return
    }
}
