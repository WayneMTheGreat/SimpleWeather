//
//  CityList.swift
//  TheWeather
//
//  Created by Wayne Mosley on 6/30/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation

struct City: Codable{
    var id: Int
    var name: String
    var country: String
    var coord: [String:Double]
}
