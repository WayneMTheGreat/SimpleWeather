//
//  cityBuilder.swift
//  TheWeather
//
//  Created by Wayne Mosley on 6/30/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation


struct CityBuilder{
    
    static func buildCityList()->[City]?{
        let dataURL = URL(fileURLWithPath: Bundle.main.path(forResource: "city.list.json", ofType: nil)!)
        do{
        let cities = try JSONDecoder().decode([City].self,from: Data(contentsOf: dataURL ))
            return cities
        }
        catch{ let error = error
            print("\(error)")
            
        }
       return nil
    }
}
