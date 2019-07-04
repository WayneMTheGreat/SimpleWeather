//
//  GettingLocation.swift
//  TheWeather
//
//  Created by Wayne Mosley on 4/27/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//

import Foundation
import CoreLocation


class WeatherLocation: NSObject{
    //Time to put on my big boy pants and start making this weather app better.
    
    
    let locationManager = CLLocationManager()
    
    
    override init(){
        
        super.init()
        //locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = 85
        self.locationManager.distanceFilter = 1

    }
    
   
}
