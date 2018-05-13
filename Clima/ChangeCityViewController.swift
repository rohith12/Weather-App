//
//  ChangeCityViewController.swift
//  WeatherApp


import UIKit



protocol ChangeCityDelegate {
    func useEnteredANewCityName(city: String)
}



class ChangeCityViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        let cityName = changeCityTextField.text
        
        if cityName != nil{
            
            delegate?.useEnteredANewCityName(city: cityName!)
            
            self.dismiss(animated: true, completion: nil)
            
        }
       
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
