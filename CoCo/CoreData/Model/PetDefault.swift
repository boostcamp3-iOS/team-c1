//
//  PetDefault.swift
//  CoCo
//
//  Created by 강준영 on 18/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

class PetDefault {
    static let shared = PetDefault()
    var pet: Pet = Pet.dog
}
