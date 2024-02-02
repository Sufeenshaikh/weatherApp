//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate=self
        searchTextField.delegate=self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}



extension WeatherViewController : UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        searchTextField.text = ""
        print(searchTextField.text!)
        return true
    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text = ""{
//            return true
//        }else{
//            textField.placeholder = "type something"{
//            return false
//        }
//    }
//
    func textFieldDidEndEditing(_ textField: UITextField) {
        //searchTextField = ""
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
    }
}


extension WeatherViewController : WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempratureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
       locationManager.stopUpdatingLocation()
                    let lat = location.coordinate.latitude
                    let lon = location.coordinate.longitude
                    weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
