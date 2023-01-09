//
//  DataService.swift
//  MoutainPassRoadCondition
//
//  Created by Frank on 2022-12-19.
//

import Foundation

typealias CompletionHandler = ([PassConditionModel]) -> Void

class DataService {
    
    let url: URL
    
    var allPassConditions:[PassConditionModel] = [PassConditionModel]()
    
    init(accessCode: String = "92d9dddb-c3d0-48e1-af2b-0ec4709d42aa") {
        url = URL(string: "https://wsdot.wa.gov/Traffic/api/MountainPassConditions/MountainPassConditionsREST.svc/GetMountainPassConditionsAsJson?AccessCode=\(accessCode)")!
    }
    
    func getPassCondition(_ completionBlock: @escaping CompletionHandler) {
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    
                    let modelList = try decoder.decode([PassConditionModel].self, from: data)
                    
                    completionBlock(modelList)
                    
                } catch {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
}
