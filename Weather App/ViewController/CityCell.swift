//
//   Diğer özellikleri ayarlayabilirsiniz     } } CityCell.swift
//  Weather App
//
//  Created by Onur Sir on 27.05.2023.
//

import UIKit

class CityCell: UITableViewCell {
    // Hücre içerisindeki IBOutlet'leri tanımlayabilirsiniz
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    var city: City? // Hücrenin temsil ettiği şehir verisini tutan özellik
    
    // Hücreye tıklandığında çalışacak yöntem
    func didSelectCell() {
        guard let city = city else {
            return
        }
        
        // Şehir ID'sini kullanarak API'dan hava durumu verilerini al
        WeatherAPIManager.fetchWeatherData(cityID: String(city.id)) { [weak self] weatherData in
            DispatchQueue.main.async {
                if let weatherData = weatherData {
                    // Hava durumu verilerini güncelle
                    self?.updateWeatherData(weatherData)
                } else {
                    print("Hava durumu verileri alınamadı.")
                }
            }
        }
    }
    
    // Hava durumu verilerini güncelle
    func updateWeatherData(_ weatherData: WeatherData) {
        currentLabel.text = "Current: \(weatherData.main.temp) °C"
        feelsLike.text = "Feels Like: \(weatherData.main.feels_like) °C"
        maxTemp.text = "H: \(weatherData.main.temp_max) °C"
        lowTemp.text = "L: \(weatherData.main.temp_min) °C"
    }
}


