//
//  Classes.swift
//  TestProjectMonyList
//
//  Created by Zimma on 05/09/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

import Foundation

struct Stock: Decodable {
    let stock: [Mony]
}

struct Mony: Decodable {
    let name: String
    let volume: Int
    let price: Price
    
}

struct Price: Decodable {
    let amount: Double
}

