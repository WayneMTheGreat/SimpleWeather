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
    
    static func buildCityListString()->[String]{
        var cityStringArray = [String]()
        let dataURL = Bundle.main.path(forResource: "city.list", ofType: "json")!
        do{
            var cityListString = try String(contentsOfFile: dataURL, encoding: .utf8)
            cityListString = cityListString.replacingOccurrences(of: "/", with: "")
            cityStringArray = cityListString.components(separatedBy: "},")

        }
        catch{ let error = error
            print("\(error)")
            
        }
        return cityStringArray
    }
    static func mergesSort(cities: [City]) -> [City]{
        var sortedCities = [City]()
        guard cities.count > 1 else{return cities}
        
        let mid = cities.count/2
        let left = mergesSort(cities: Array(cities[..<mid]))
        let right = mergesSort(cities: Array(cities[mid...]))
        
        sortedCities = merge(left: left, right: right)
        
        return sortedCities
    }
    
   private static func merge(left: [City], right: [City])->[City]{
        var leftIndex = 0
        var rightIndex = 0
        var result: [City] = []
        
        while leftIndex < left.count && rightIndex < right.count{
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]
            if leftElement.id < rightElement.id{
                result.append(leftElement)
                leftIndex += 1}
            else if leftElement.id > rightElement.id{
                result.append(rightElement)
                rightIndex += 1
                
            }else {
                result.append(leftElement)
                leftIndex += 1
                result.append(rightElement)
                rightIndex += 1
                
            }
        }
        if leftIndex < left.count {
            result.append(contentsOf: left[leftIndex...])
        }
        if rightIndex < right.count{
            result.append(contentsOf: right[rightIndex...])
        }
        return result
    }

    
    static func binarySearch(for city: String, inCities: [City])->Bool{
        var foundCity: City?
        
        var start = 0
        var end = inCities.count - 1
        let mid = (start + end)/2
        
        while (start <= end){
            if (inCities[mid].name < city ){
                start = mid + 1
            }else if (inCities[mid].name > city){
                end = mid - 1
            }else{
                foundCity = inCities[mid]
                return true
            }
        }
        return false
    }
}
