//
//  MockLoader.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 3/4/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation
@testable import WaterMyPlants

class MockLoader: NetworkDataLoader {

    var data: Data?
    var error: Error?
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            completion(self.data, self.error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            completion(self.data, self.error)
        }
    }
}
