//
//  SearchServiceClass.swift
//  CoCo
//
//  Created by 이호찬 on 01/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class SearchService {
    let coreDataManager: CoreDataManagerProtocol
    let networkManager: NetworkManagerType
    let algorithmManager: Algorithm
    
    init(core: CoreDataManagerProtocol, network: NetworkManagerType, algorithm: Algorithm) {
        self.coreDataManager = core
        self.networkManager = network
        self.algorithmManager = algorithm
    }
    
    
}
