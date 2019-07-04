//
//  WeatherAPI.swift
//  TheWeather
//
//  Created by Wayne Mosley on 3/18/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//

import Foundation

//The API should build the URL, parse the JSON and then hand off the data to another class.

struct WeatherAPI{
    
    private static let APIKey = ""
    private var apiURLComponents = URLComponents()
    
    private var weatherURL = "api.openweathermap.org/data/2.5/"
    {
        didSet{
            url = URL(string: weatherURL)
        }
    }
    var url = URL(string: "")
    private var weatherForecastURL = "https://api.wunderground.com/api/\(APIKey)/forecast/q/MD/Baltimore.json"
    var State = ""
    var City = ""
    private let webSession = URLSession(configuration: .default)
    
    //Once the location is set update all URLS with the latest location.
    var location = (latitude: 0.0, longitude:0.0){
        didSet{
            weatherURL = "https://api.wunderground.com/api/\(WeatherAPI.APIKey)/conditions/q/\(location.latitude),\(location.longitude).json"
            weatherForecastURL = "https://api.wunderground.com/api/\(WeatherAPI.APIKey)/forecast/q/\(location.latitude),\(location.longitude).json"
            
        }
    }
    
    //Allows City and state search.
    var searchString = [String]()
    
    var zipString = String()
    
    
    mutating func buildURLForZip(zip: String)-> URL{
        apiURLComponents.scheme = "https"
        apiURLComponents.host = "api.openweathermap.org"
        apiURLComponents.path = "/data/2.5/weather"
        apiURLComponents.queryItems = [
            URLQueryItem(name:"zip", value: zip),
        URLQueryItem(name:"APPID", value:
            WeatherAPI.APIKey)]
        let url = apiURLComponents.url
        print("\(url!)")
        return url!
    }
    
    mutating func buildURLForCityState(cityState: String)-> URL{
        apiURLComponents.scheme = "https"
        apiURLComponents.host = "api.openweathermap.org"
        apiURLComponents.path = "/data/2.5/weather"
        apiURLComponents.queryItems = [
            URLQueryItem(name:"q", value: cityState),
            URLQueryItem(name:"APPID", value:
                WeatherAPI.APIKey)]
        let url = apiURLComponents.url
        print("\(url!)")
        return url!
    }
    
    mutating func buildURLForID(ID: Int)-> URL{
        apiURLComponents.scheme = "https"
        apiURLComponents.host = "api.openweathermap.org"
        apiURLComponents.path = "/data/2.5/weather"
        apiURLComponents.queryItems = [
            URLQueryItem(name:"id", value: String(ID)),
            URLQueryItem(name:"APPID", value:
                WeatherAPI.APIKey),
            URLQueryItem(name: "units", value: "imperial")]
        let url = apiURLComponents.url
        print("\(url!)")
        return url!
    }
    //Get the current conditions for the day from the WeatherUnderground API
    func getWeatherConditions(for url: URL, completion: @escaping (Forecast)-> Void){
        
        let urlRequest = URLRequest(url: url)
        let task = webSession.dataTask(with: urlRequest){data,_, error in
            
            if error == nil{ //Handling the crash that occurs with no internet connection.
                do{
                    if let data = data{
                    let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                    
                    //let myCast = Forecast(conditionsFromJSON: jsonData)
                    
                    OperationQueue.main.addOperation {
                        completion(forecast)// Rewrite to handle the no internet connection error.
                    }
                    }
                    
                }
                catch{
                    print("JSON Data Not Valid. We had error \(error).")
                }
                
            }else{
                //Really handle
                print(String(describing: error.debugDescription))
            }
        }
        task.resume()
        
    }
    
    //Get multiday forecast
    
    func getWeatherForecast(completion: @escaping ([(Forecast)])-> Void){
        
        let url = URL(string: weatherForecastURL)
        let urlRequest = URLRequest(url: url!)
        
        let task = webSession.dataTask(with: urlRequest){data,_, error in
            
            if error == nil{// Handling the crash that occurs with no internet connection.
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                    //let threeDayCast = Forecast(threeDayFromJSON: jsonData)
                    OperationQueue.main.addOperation {
                        completion([Forecast]())//Re-write this to handle the no internet connection error.
                    }
                }
                catch{
                    print("JSON Data Not Valid")
                }
                
            }else{
                //Really handle.
                print(String(describing: error.debugDescription))
            }
        }
        task.resume()
        
    }
    func printLocation(){
        print("My location is latitude: \(location.latitude) and longitude: \(location.longitude)")
    }
    
    
}
