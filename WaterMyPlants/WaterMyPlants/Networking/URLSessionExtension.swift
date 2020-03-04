//
//  URLSessionExtension.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/4/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let loadDataTask = dataTask(with: request) { possibleData, _, possibleError in
            
            if let error = possibleError {
                NSLog("Error fetching data: \(error)")
            }
            
            guard let data = possibleData else {
                completion(nil, possibleError)
                return
            }
            completion(data, nil)
        }
        loadDataTask.resume()
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let loadDataTask = dataTask(with: url) { possibleData, _, possibleError in
            completion(possibleData, possibleError)
        }
        loadDataTask.resume()
    }
}
