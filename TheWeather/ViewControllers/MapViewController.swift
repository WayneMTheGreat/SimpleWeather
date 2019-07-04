//
//  MapViewController.swift
//  TheWeather
//
//  Created by Wayne Mosley on 5/6/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    /*Still need to make the app zoom into the users current location instead of showing the entire united states. */ // - Done
    
    var location:WeatherLocation?
    var homeLocation = CLLocation()
    var homeLocation2 = CLLocation(latitude: 45, longitude: -76)
    var region: MKCoordinateRegion?
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        location!.locationManager.delegate = self
        centerMapOnLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(){
        
        location?.locationManager.startUpdatingLocation()
        
        print("The location is: \(String(describing: location?.locationManager.location))")
        let gpsLocation = location?.locationManager.location
        homeLocation = gpsLocation ?? homeLocation2
        region = MKCoordinateRegion(center: (homeLocation.coordinate),span: span)
        mapView.setRegion(region!, animated: true)
        location?.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - MapView Delegate
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        location?.locationManager.startUpdatingLocation()
        
        print("The location is: \(String(describing: location?.locationManager.location))")
        let gpsLocation = location?.locationManager.location
        homeLocation = gpsLocation ?? homeLocation2
        region = MKCoordinateRegion(center: (homeLocation.coordinate),span: span)
        mapView.setRegion(region!, animated: true)
        location?.locationManager.stopUpdatingLocation()
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

// MARK: - CLLocationManagerDelegate Extension
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            print("We got location. It's lit")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations{
            print("\(location.coordinate)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
}
