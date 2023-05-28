//
//  ViewControllerCities.swift
//  Weather App
//
//  Created by Onur Sir on 24.05.2023.
//

import UIKit

class ViewControllerCities: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var weatherDataUpdateCallback: ((WeatherData) -> Void)?

    var cities: [City] = [] // Şehir verilerini tutacak dizi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate ve DataSource ayarları
        tableView.delegate = self
        tableView.dataSource = self
        
        // Şehir verilerini yükle
        loadCityData()
        // Search Bar ayarları
            searchBar.delegate = self
            searchBar.placeholder = "Şehir Ara"
    }
    
    func loadCityData() {
        if let path = Bundle.main.path(forResource: "city", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                cities = try decoder.decode([City].self, from: data)
                tableView.reloadData()
            } catch {
                print("JSON çözme hatası: \(error)")
            }
        } else {
            print("JSON dosyası bulunamadı.")
        }
    }
    
    //MARK: - Search BAR
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          if let searchText = searchBar.text {
              searchCity(with: searchText)
          }
      }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadCityData() // Şehir ismi boş ise tüm şehirleri göster
        } else {
            searchCity(with: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
        loadCityData() // Tüm şehirleri göstermek için orijinal verileri yükle
    }


      
      func searchCity(with searchText: String) {
          // Arama sonuçlarını içerecek bir dizi oluştur
          var searchResults: [City] = []
          
          // Şehirleri döngüyle kontrol et ve aranan kelimeye uyanları searchResults dizisine ekle
          for city in cities {
              if city.name.lowercased().contains(searchText.lowercased()) {
                  searchResults.append(city)
              }
          }
          
          // Arama sonuçlarını göstermek için tableView'ı yeniden yükle
          if searchResults.isEmpty {
              // Arama sonucu bulunamadıysa, tüm şehirleri göster
              tableView.reloadData()
          } else {
              // Arama sonucu bulunduysa, sadece sonuçları göster
              cities = searchResults
              tableView.reloadData()
          }
      }
      
     
      
    

        
        // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cities.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            let city = cities[indexPath.row]
            cell.textLabel?.text = city.name
            return cell
        }
        
        // MARK: - UITableViewDelegate
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        
        // Şehir ID'sini kullanarak API'dan hava durumu verilerini al
        getWeatherData(cityID: String(selectedCity.id)) { [weak self] weatherData in
            DispatchQueue.main.async {
                if let weatherData = weatherData {
                    // Seçilen şehrin weatherData özelliğini güncelle
                    var updatedCity = selectedCity
                    updatedCity.weatherData = weatherData
                    self?.cities[indexPath.row] = updatedCity
                    
                    // Hava durumu verilerini ViewController'da göster
                    self?.showWeatherData(weatherData)
                   
                } else {
                    print("Hava durumu verileri alınamadı.")
                }
            }
        }
    }
    func showWeatherData(_ weatherData: WeatherData) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            viewController.weatherData = weatherData
            viewController.weatherDataUpdateCallback = { [weak self] updatedWeatherData in
                self?.updateWeatherData(updatedWeatherData)
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
    }



    func updateWeatherData(_ weatherData: WeatherData) {
        // Seçilen şehri cities dizisinde bulun ve hava durumu verilerini güncelle
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            var selectedCity = cities[selectedIndexPath.row]
            selectedCity.weatherData = weatherData
            cities[selectedIndexPath.row] = selectedCity
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
    }





    func getWeatherData(cityID: String, completion: @escaping (WeatherData?) -> Void) {
        WeatherAPIManager.fetchWeatherData(cityID: cityID) { weatherData in
            completion(weatherData)
        }
    }

    }
