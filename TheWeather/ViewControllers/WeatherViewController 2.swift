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
    
    
    var searchController: UISearchController!
    lazy var cities = {
        CityBuilder.buildCityList()
    }()
    var filteredCities: [City]?
    var resultsTableView: SearchResultsTableViewController!
    var theWeather = WeatherAPI() //Initialize a WeatherAPI. Probably should be dependency injected. This needs to be corrected. Past me was correct. It is being dependency injected and then overwritten here as well.
    var theForecast = Forecast(){
        didSet{
            //Forecast set.
            //setUpUIForSingleDay(forecast: theForecast)
        }
    }
    var location:WeatherLocation?
    var threeDay = [Forecast](){//When my 3 day forecast is set reload the tableview to show it on the MAIN THREAD. Also load the three day into the Store.
        didSet{
            
            thisTable.reloadData()
            //forecastStore?.addLocation(location: theForecast.weatherCity, tuple: (theForecast, threeDay))
        }
    }
    var forecastStore:ForecastStore?{//Struct to store the forecasts.
        didSet{
            print("I'm all locked in.")
            //print("\(String(describing: forecastStore))")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar.delegate = self
        resultsTableView = SearchResultsTableViewController()
        resultsTableView.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultsTableView)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        setUpUIForSingleDay(forecast: theForecast)
       /* theWeather.getWeatherConditions(for: theWeather.buildURLForZip(zip: "21213")){cast in
            self.theForecast = cast
            self.temperatureLabel.text = ""
            self.condtionsLabel.text = ""
            self.locationLabel.text = ""
            //self.setImageForWeatherUI()
            
        }*/
       /* theWeather.getWeatherForecast() { (forecasts) in
            self.threeDay = forecasts
        }*/
        
    }
    
    func testingAction(){
        print("This function was called from a segue push")
    }
    
    
    // MARK: - TableView DataSource Methods.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threeDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ForecastTableViewCell
        
        cell.conditionsLabel?.text = "Hold"
        cell.temperatureLabel?.text = "Hold"
        //setImageForWeather(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityIDURL = theWeather.buildURLForID(ID: (filteredCities?[indexPath.row].id)!)
        theWeather.getWeatherConditions(for: cityIDURL){forecast in
            self.theForecast = forecast
            self.setUpUIForSingleDay(forecast: self.theForecast)
        }
        searchController.isActive = false
    
    }
    
    // MARK: - Location Action Methods
    
    @IBAction func getLocation(_ sender: UIButton) {
        
        // Using the location mananger to configure and get the users current location.
        location?.locationManager.startUpdatingLocation()
        location?.locationManager.stopUpdatingLocation()
        let inLocation = location?.locationManager.location
        if let latitude = inLocation?.coordinate.latitude{
            theWeather.location.latitude = Double(latitude)
        }
        if let longitude = inLocation?.coordinate.longitude{
            theWeather.location.longitude = Double(longitude)
        }
        
        
        /* //Redo the Main Forecast with the current locations weather.
         theWeather.getWeatherConditions(for: <#URL#>) { (cast) in
         self.theForecast = cast
         self.temperatureLabel.text = ""
         self.condtionsLabel.text = ""
         self.locationLabel.text = ""
         //self.setImageForWeatherUI()
         //self.forecastStore?.addLocation(location: self.theForecast.weatherCity, tuple: (self.theForecast, []))//append new values to the store.
         
         
         }
         
         
         //Redo the 3 day Forecast with the current locations weather.
         theWeather.getWeatherForecast { (forecasts) in
         self.threeDay = forecasts
         self.thisTable.reloadData()
         
         
         }*/
        
    }
    
    
    // MARK: - SearchBar Delegate Methods.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text?.components(separatedBy: ","){
            print("\(searchString)")
            if Int(searchString[0]
                ) != nil && searchString[0].count == 5{
                _ = theWeather.buildURLForZip(zip: searchString[0])
                //theWeather.getWeatherConditions
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
    /*func setUpUIForMultiDay(forecast: [Forecast]){
     self.theForecast = cast
     self.temperatureLabel.text = String(cast.temperature)
     self.condtionsLabel.text = cast.weather
     self.locationLabel.text = cast.weatherCity
     self.setImageForWeatherUI()
     self.forecastStore?.addLocation(location: self.theForecast.weatherCity, tuple: (self.theForecast, []))//append new values to the store.
     
     }*/
    
    /*  func setImageForWeather( cell: ForecastTableViewCell, indexPath: IndexPath){
     
     switch self.threeDay[indexPath.row].weather{
     case "overcast clouds: 85-100%":
     cell.weatherImage.image = UIImage(named: "Overcast.PNG")
     case "Partly Cloudy":
     cell.weatherImage.image = UIImage(named: "Partly Cloudy.PNG")
     case "Mostly Cloudy":
     cell.weatherImage.image = UIImage(named: "Overcast.PNG")
     case "Rain","Rainy":
     cell.weatherImage.image = UIImage(named: "Rainy.PNG")
     case "Chance of a Thunderstorm":
     cell.weatherImage.image = UIImage(named: "Chance of thunderstorm.png")
     case "Thunderstorm":
     cell.weatherImage.image = UIImage(named: "Thunderstorm.png")
     default:
     cell.weatherImage.image = UIImage(named: "Sunny.PNG")
     
     }
     
     }*/
     
     func setImageForWeatherUI(){
     switch theForecast.weather?[0].description{
     case "overcast clouds", "broken clouds", "scatter clouds", "few clouds ":
     self.weatherImage.image = UIImage(named: "Overcast.PNG")
     case "Partly Cloudy":
     self.weatherImage.image = UIImage(named: "Partly Cloudy.PNG")
     case "Mostly Cloudy":
     self.weatherImage.image = UIImage(named: "Overcast.PNG")
     case "Rain","Rainy","Chance of Rain":
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
        filteredCities = cities?.filter({ (city: City) -> Bool in
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


