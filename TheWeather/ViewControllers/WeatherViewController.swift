//
//  WeatherViewController.swift
//  TheWeather
//
//  Created by Wayne Mosley on 3/18/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var condtionsLabel: UILabel!
    @IBOutlet weak var thisTable: UITableView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
    var passedLocation = String()
    var searchController: UISearchController!
    lazy var cities = {
        CityBuilder.buildCityList()
    }()
    var sortedCities = [City](){
        didSet{
            print("I changed.")
            
        }
    }
    var filteredCities: [City]?
    var resultsTableView: SearchResultsTableViewController!
    var theWeather = WeatherAPI()
    var theForecast = Forecast()
    var location:WeatherLocation?
    var fiveDay = MultiForecast(){
        didSet{
            thisTable.reloadData()
        }
    }
    var forecastStore:ForecastStore?{//Struct to store the forecasts.
        didSet{
            print("I'm all locked in.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            self.sortedCities = CityBuilder.mergesSort(cities: self.cities!)
        }
        resultsTableView = SearchResultsTableViewController()
        resultsTableView.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultsTableView)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        setUpUIForSingleDay(forecast: theForecast)
    }
    

    func testingAction(enteredLocation: [String]){
        print("This function was called from a segue push")
        self.passedLocation = enteredLocation[0]
        if passedLocation.count == 5 && !passedLocation.contains(","){
            theWeather.getWeatherConditions(for: theWeather.buildURLForZip(zip: passedLocation)) { (forecast) in
                self.theForecast = forecast
                self.setUpUIForSingleDay(forecast: forecast)
            }
            theWeather.getWeatherForecast(url: theWeather.buildURLForZipMulti(zip: passedLocation)) { (forecasts) in
                self.fiveDay = forecasts
            }
        }else if enteredLocation.count == 2{
            print("hold")
            theWeather.getWeatherConditions(for: theWeather.buildURLForCityState(cityState: enteredLocation[0])){ (forecast) in
                self.theForecast = forecast
                self.setUpUIForSingleDay(forecast: forecast)
            }
            theWeather.getWeatherForecast(url: theWeather.buildURLForCityStateMulti(cityState: enteredLocation[0])) { (forecasts) in
                self.fiveDay = forecasts
            }
        }
    }
    // MARK: - TableView DataSource Methods.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDay.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ForecastTableViewCell
        cell.conditionsLabel?.text = fiveDay.list![indexPath.row].weather![0].description
        cell.temperatureLabel?.text = String(describing: fiveDay.list![indexPath.row].main!.temp!.rounded())
        setImageForWeather(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == thisTable{
            print("Please fix me.")}
        else{
            let cityIDURL = theWeather.buildURLForID(ID: (filteredCities?[indexPath.row].id)!)
            theWeather.getWeatherConditions(for: cityIDURL){forecast in
                self.theForecast = forecast
                self.setUpUIForSingleDay(forecast: self.theForecast)
            }
            searchController.isActive = false
        }
        
    }
    
    // MARK: - Location Action Methods
    
    @IBAction func getLocation(_ sender: UIButton) {
        
        // Using the location mananger to configure and get the users current location.
        location?.locationManager.startUpdatingLocation()
        location?.locationManager.stopUpdatingLocation()
        let inLocation = location?.locationManager.location
        if let latitude = inLocation?.coordinate.latitude, let longitude = inLocation?.coordinate.longitude{
            theWeather.location.latitude = Double(latitude)
            theWeather.location.longitude = Double(longitude)
            theWeather.getWeatherConditions(for: theWeather.buildURLForLatLon(latitude: Double(latitude), longitude: Double(longitude))) {forecast in
                self.theForecast = forecast
                self.setUpUIForSingleDay(forecast: self.theForecast)
            }
            theWeather.getWeatherForecast(url: theWeather.buildURLForLatLonMulti(latitude: Double(latitude), longitude: Double(longitude))) { forecasts in
                self.fiveDay = forecasts
            }
            
        }
    }
    
    
    // MARK: - SearchBar Delegate Methods.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text?.components(separatedBy: ","){
            print("\(searchString)")
            if Int(searchString[0]
                ) != nil && searchString[0].count == 5{
                _ = theWeather.buildURLForZip(zip: searchString[0])
            }else{
                var value = searchString
                guard !value.isEmpty else{return}
                switch value[0].contains(" "){
                case true:
                    value[0] = value[0].replacingOccurrences(of: " ", with: " ")
                    if value.count > 1 && value[1].contains(" "){
                        value[1] = value[1].replacingOccurrences(of: " ", with: "")
                        print("here")
                        _ = theWeather.buildURLForCityState(cityState: value[0] + "," + value[1] + ",")
                    }else if value.count>1{
                        _ = theWeather.buildURLForCityState(cityState: value[0] + "," + value[1] + ",")
                    }else{
                        _ = theWeather.buildURLForCityState(cityState: value[0])
                    }
                case false:
                    if value.count > 1 {
                        if value[1].contains(" "){
                            value[1] = value[1].replacingOccurrences(of: " ", with: "")
                            _ = theWeather.buildURLForCityState(cityState: value[0] + "," + value[1] + ",")
                        }else{
                            _ = theWeather.buildURLForCityState(cityState: value[0] + "," + value[1] + ",")
                        }
                    }else{
                        _ = theWeather.buildURLForCityState(cityState: value[0])
                    }
                }
            }
        }
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    // MARK: - Methods to stop repeating code so much.
    
    //Cell Image Setting Function
    
    func setUpUIForSingleDay(forecast: Forecast){
        self.theForecast = forecast
        guard let temp = forecast.main?.temp else{return}
        self.temperatureLabel.text = String(describing: temp.rounded()) //(0K − 273.15) × 9/5 + 32
        self.condtionsLabel.text = forecast.weather?[0].description
        self.locationLabel.text = forecast.name
        self.setImageForWeatherUI()
        
        
    }
    /* func setUpUIForMultiDay(forecasts: MultiForecast){
     //self.theForecast = cast
     guard let temp = forecasts.list.main?.temp else{return}
     self.temperatureLabel.text = String(describing: temp.rounded()) //(0K − 273.15) × 9/5 + 32
     self.condtionsLabel.text = forecasts.list.weather?[0].description
     self.locationLabel.text = forecasts.list.name
     self.setImageForWeatherUI()
     //self.forecastStore?.addLocation(location: self.theForecast.weatherCity, tuple: (self.theForecast, []))//append new values to the store.
     
     }*/
    
    func setImageForWeather( cell: ForecastTableViewCell, indexPath: IndexPath){
        
        switch self.fiveDay.list![indexPath.row].weather![0].description{
        case "overcast clouds", "broken clouds", "few clouds ":
            cell.weatherImage.image = UIImage(named: "Overcast.PNG")
        case "Partly Cloudy", "scatter clouds", "scattered clouds":
            cell.weatherImage.image = UIImage(named: "Partly Cloudy.PNG")
        case "Mostly Cloudy":
            cell.weatherImage.image = UIImage(named: "Overcast.PNG")
        case "rain","rainy","Chance of Rain", "light rain":
            cell.weatherImage.image = UIImage(named: "Rainy.PNG")
        case "Chance of a Thunderstorm":
            cell.weatherImage.image = UIImage(named: "Chance of thunderstorm.png")
        case "Thunderstorm":
            cell.weatherImage.image = UIImage(named: "Thunderstorm.png")
        default:
            cell.weatherImage.image = UIImage(named: "Sunny.PNG")
            
        }
        
    }
    
    func setImageForWeatherUI(){
        switch theForecast.weather?[0].description{
        case "overcast clouds", "broken clouds", "few clouds ":
            self.weatherImage.image = UIImage(named: "Overcast.PNG")
        case "Partly Cloudy", "scatter clouds", "scattered clouds":
            self.weatherImage.image = UIImage(named: "Partly Cloudy.PNG")
        case "Mostly Cloudy":
            self.weatherImage.image = UIImage(named: "Overcast.PNG")
        case "rain","rainy","Chance of Rain", "light rain":
            self.weatherImage.image = UIImage(named: "Rainy.PNG")
        case "Chance of a Thunderstorm":
            self.weatherImage.image = UIImage(named: "Chance of thunderstorm.png")
        case "Thunderstorm":
            self.weatherImage.image = UIImage(named: "Thunderstorm.png")
        default:
            self.weatherImage.image = UIImage(named: "Sunny.PNG")
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

// MARK: - Search Controller Delegate Methods
extension WeatherViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterJSONArrayForCity(searchString: searchController.searchBar.text!)
        resultsTableView.filteredCities = filteredCities
        resultsTableView.tableView.reloadData()
        
    }
    
    func filterJSONArrayForCity (searchString: String){
        filteredCities = sortedCities.filter({ (city: City) -> Bool in
            return city.name.lowercased().contains(searchString.lowercased())
        })
    }
    
}

extension WeatherViewController: UISearchControllerDelegate{
    func presentSearchController(_ searchController: UISearchController) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        // Hold
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        // Hold
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        // Hold
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // Hold
    }
}


