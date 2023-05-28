//
//  ViewController.swift
//  Weather App
//
//  Created by Onur Sir on 24.05.2023.
//


// başlangıçta konum alma eklenecek.
// tableview'da bazı verilere tıklanınca hata alınıyor. onu alert şeklinde göster
// ve alert'de api'dan veri alınamıyor lütfen başka bir şehire bakınız.
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBOutlet weak var highestLabel: UILabel!
    
    @IBOutlet weak var lowestLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var windGustLabel: UILabel!
    
    @IBOutlet weak var seaLevelLabel: UILabel!
    
    @IBOutlet weak var lotitudeLabel: UILabel!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var weatherData: WeatherData?
    var weatherDataUpdateCallback: ((WeatherData) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let weatherData = weatherData {
            displayWeatherData(weatherData)
        } else {
            // Hava durumu verileri yoksa, verileri almak için gereken işlemleri yapabilirsiniz.
            getWeatherData(cityID: "745044") { [weak self] weatherData in
                if let weatherData = weatherData {
                    self?.weatherData = weatherData
                    self?.displayWeatherData(weatherData)
                } else {
                    print("Hava durumu verileri alınamadı.")
                }
            }
        }
        
        
            }

    func getWeatherData(cityID: String, completion: @escaping (WeatherData?) -> Void) {
        WeatherAPIManager.fetchWeatherData(cityID: cityID) { [weak self] weatherData in
            DispatchQueue.main.async {
                completion(weatherData)
            }
        }
    }


    func updateWeatherData(_ updatedWeatherData: WeatherData) {
        weatherData = updatedWeatherData
        displayWeatherData(updatedWeatherData)
        
        // Güncellenmiş hava durumu verilerini geri çağırma yöntemiyle ViewControllerCities sınıfına iletiyoruz
        weatherDataUpdateCallback?(updatedWeatherData)
        
     
    }



    func displayWeatherData(_ weatherData: WeatherData) {
        cityNameLabel.text = weatherData.name
        currentLabel.text = "Current: \(weatherData.main.temp) °C"
        feelsLikeLabel.text = "Feels Like: \(weatherData.main.feels_like) °C"
        highestLabel.text = "H: \(weatherData.main.temp_max) °C"
        lowestLabel.text = "L: \(weatherData.main.temp_min) °C"
        humidityLabel.text = "\(weatherData.main.humidity) %"
        
        let windSpeed = Int(weatherData.wind.speed * 3.6)
        windSpeedLabel.text = "\(windSpeed) km/h"
        
        let windGust = Int(Double(weatherData.wind.deg) * 3.6)
        windGustLabel.text = "\(windGust) km/h"
        
        seaLevelLabel.text = "\(weatherData.main.pressure) hPa"
        lotitudeLabel.text = "Latitude: \(String(format: "%.0f", weatherData.coord.lat))"
        longitudeLabel.text = "Longitude: \(String(format: "%.0f", weatherData.coord.lon))"
        
        weatherDescriptionLabel.text = weatherData.weather.first?.description
    }
 


    
}



