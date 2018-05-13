//
//  ViewController.swift
//  WeatherApp


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate,ChangeCityDelegate {
   
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1eb260de57df02cedfcb9f239f2174cd"
    

    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //TODO:Set up the location manager here.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    

    func getWatherData(url: String,parameters: [String: String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess{
                
                let jsonWeather = JSON(response.result.value!)
                self.updateWeatherData(json: jsonWeather)
                
            }else{
                print("error:\(String(describing: response.result.error))")
                self.cityLabel.text = "Network not available"
            }
            
            
        }
        
        
    }
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    func updateWeatherData(json: JSON){
        
        if let temp = json["main"]["temp"].double{
            
          weatherDataModel.temp = Int(temp - 273.15)
          weatherDataModel.city = json["name"].stringValue
          weatherDataModel.conditions = json["weather"][0]["id"].intValue
          weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.conditions)
          updateUIWithWeatherData()
        }else{
            cityLabel.text = "Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temp)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let param: [String:String] = ["lat":latitude,"lon":longitude,"appid":APP_ID]
            getWatherData(url: WEATHER_URL, parameters: param)
        }
    }
    
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    func useEnteredANewCityName(city: String) {
        print(city)
        let param: [String:String] = ["q":city,"appid":APP_ID]
        getWatherData(url: WEATHER_URL, parameters: param)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName"{
            
            let vc = segue.destination as! ChangeCityViewController
            
            vc.delegate = self
        }
    }
    
    
    
    
}


