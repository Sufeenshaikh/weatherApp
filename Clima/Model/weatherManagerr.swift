//
//  weatherManagerr.swift
//  Clima
//
//  Created by Rohit Dhakad on 17/03/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFailWithError(error: Error)  
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ce6343f6700437faa6cd40e845f328ea&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
}
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        // 1. create a url
        let url = URL(string: urlString)!
        
        //2. create a url session
        let session = URLSession(configuration: .default)
        
        //3. give session a task
        
        //let task = session.dataTask(with: url!, completionHandler: handle(data: response: error:))
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil{
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data{
//                let dataString = String(data: safeData, encoding: .utf8)
//                print(dataString)
                if let weather = parseJSON(weatherData: safeData){
                    self.delegate?.didUpdateWeather(self, weather : weather)
            }
          }
        }
        //4. start the task
        task.resume()
    }
    
    //let decoder: JSONDecoder
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
           
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
  }
    
    }

