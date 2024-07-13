//
//  MapService.swift
//  CoreLocationPock
//
//  Created by user on 21/02/24.
//

import Foundation
import UIKit

class MapService {
    var baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?address="
    
    
    func getAddressData(address: String, completion: @escaping (Result<AddressResultModel?, Error>) -> Void){
        var key = ""
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            key = "&key=\(appDelegate.key)"
        }
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
                print(error.localizedDescription)
                completion(.failure(error))
            }
        })
        
        dataTask.resume()
        return
    }
}
