//
//  DataService.swift
//  MoutainPassRoadCondition
//
//  Created by Frank on 2022-12-19.
//

import Foundation

class DataService {
    
    let accessCode: String
    let mountainPassId: Int
    let url: URL
    
    init(accessCode: String = "92d9dddb-c3d0-48e1-af2b-0ec4709d42aa", mountainPassId: Int = 11) {
        self.accessCode = accessCode //
        self.mountainPassId = mountainPassId
        
        url = URL(string: "https://wsdot.wa.gov/Traffic/api/MountainPassConditions/MountainPassConditionsREST.svc/GetMountainPassConditionAsJon?AccessCode=\(accessCode)&PassConditionID=\(mountainPassId)")!
    }
    
    func getPassCondition(_ completionBlock: @escaping ((PassConditionModel) -> Void)) {
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    
                    let model = try decoder.decode(PassConditionModel.self, from: data)
                    
                    completionBlock(model)
                } catch {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
}
