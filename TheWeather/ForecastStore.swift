//
//  ForecastStore.swift
//  TheWeather
//
//  Created by Wayne Mosley on 5/9/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//
/* This struct will hold all forecasts, detailed single day and three day, by location. This is to assist in saving so that not as many network calls have to be made.*/
import Foundation


struct ForecastStore{
    var allForecasts = [String:Any]()
    
    init(location: String, tuple: (Forecast,[Forecast])){
        
        self.allForecasts[location] = tuple
    }
    
    mutating func addLocation(location: String, tuple: (Forecast, [Forecast])){
        
        self.allForecasts[location]=tuple
    }
}
