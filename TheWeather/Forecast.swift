//
//  Forecast.swift
//  TheWeather
//
//  Created by Wayne Mosley on 4/17/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//

import Foundation

//This will at first only support a single day of weather and from there I hope to expand to multi day.

struct Forecast:Codable {
    var coord: Coordinate?
    var visibility: Int?
    var wind: [String: Double]?
    var clouds: [String:Int]?
    var main: Main?
    var weather: [Weather]?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name:String?
    var cod: Int?
    var dt_txt: String?
}
struct Coordinate:Codable{
    let lon: Double?
    let lat: Double?
}

struct Weather:Codable{
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main:Codable{
    var temp: Double?
    var pressure: Double?
    var humidity: Int?
    var temp_min: Double?
    var temp_max: Double?
}

struct Sys:Codable{
    var type: Int?
    var id: Int?
    var message: Double?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}

