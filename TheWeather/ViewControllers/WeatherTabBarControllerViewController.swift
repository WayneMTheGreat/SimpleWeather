//
//  WeatherTabBarControllerViewController.swift
//  TheWeather
//
//  Created by Wayne Mosley on 6/30/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

class WeatherTabBarControllerViewController: UITabBarController {
    var location: WeatherLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let maps = self.viewControllers?[1] as! MapViewController
        maps.location = self.location
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}