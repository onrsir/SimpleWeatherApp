//
//  WeatherAPIManager.swift
//  Weather App
//
//  Created by Onur Sir on 27.05.2023.
//

import Foundation
import CoreLocation

struct WeatherAPIManager {
    static let apiKey = "26eebf5077c0c95796131d4cdfd8d4bc"
    
    static func fetchWeatherData(cityID: String, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?APPID=\(apiKey)&units=metric&id=\(cityID)"
        
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("API isteği sırasında hata oluştu: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Veri alınamadı")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("JSON çözme hatası: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    static func fetchWeatherDataForCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?APPID=\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error during API request: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Failed to retrieve data")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    static func getWeatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?APPID=\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("API isteği sırasında hata oluştu: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Veri alınamadı")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("JSON çözme hatası: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    
    
}
