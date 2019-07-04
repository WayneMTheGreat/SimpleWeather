//
//  EntryViewController.swift
//  TheWeather
//
//  Created by Wayne Mosley on 6/5/17.
//  Copyright © 2017 Wayne Mosley. All rights reserved.
//

import UIKit


class EntryViewController: UIViewController, UITextFieldDelegate{
    
    var enteredLocation = [String]()
    let location = WeatherLocation()
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        myButton.isHidden = true
        
    }
    
    // MARK: - UITextfield delegate methods.
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("You are typing.")
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Done typing.")
        if let enteredLocation = textField.text{
            if enteredLocation.isEmpty{
                print("Please enter a city & state or zip.")
                myButton.isHidden = true
                
            }else{
                
                print("we good. \(enteredLocation)")
                //self.enteredLocation = enteredLocation
                var stringArray = enteredLocation.components(separatedBy: ",")
                print("\(stringArray)")
                //stringArray = stringArray.map{ $0.trimmingCharacters(in: .whitespaces)
                if stringArray[0].contains(" ") == true{
                    stringArray[0] = stringArray[0].replacingOccurrences(of: " ", with: " ")
                    if stringArray.count > 1 && stringArray[1].contains(" ") == true{
                        stringArray[1] = stringArray[1].replacingOccurrences(of: " ", with: "")
                    }
                }
                print("\(stringArray)")
                self.enteredLocation = stringArray
                myButton.isHidden = false
            }
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() 
        return true
    }
    
    
    //MARK: - Preparing to segue to the weather VC & passing location in.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.enteredLocation)
        if segue.identifier == "goToWeather"{
            
            let tabBarVC = segue.destination as! WeatherTabBarControllerViewController
            tabBarVC.location = self.location
            let navigationVC = tabBarVC.viewControllers?[0] as! UINavigationController
            let destinationVC = navigationVC.viewControllers.first as! WeatherViewController
            if self.enteredLocation[0].count == 5{
                destinationVC.theWeather.zipString = self.enteredLocation[0]
            }else{
                destinationVC.theWeather.searchString = self.enteredLocation}
            destinationVC.testingAction()
            destinationVC.location = location
        }
    }
    
    
}
