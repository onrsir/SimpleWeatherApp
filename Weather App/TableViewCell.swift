// TableViewCell.swift

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    var city: City? // Hücrenin temsil ettiği şehir verisini tutan özellik
    
    // Hücreye tıklandığında çalışacak yöntem
    func didSelectCell(completion: @escaping (WeatherData?) -> Void) {
        guard let city = city else {
            return
        }
        
        // Şehir ID'sini kullanarak API'dan hava durumu verilerini al
        WeatherAPIManager.fetchWeatherData(cityID: String(city.id)) { weatherData in
            DispatchQueue.main.async {
                if let weatherData = weatherData {
                    // Hava durumu verilerini güncelle
                    self.updateWeatherData(weatherData)
                } else {
                    print("Hava durumu verileri alınamadı.")
                }
                completion(weatherData)
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
