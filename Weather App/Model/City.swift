//
//  City.swift
//  Weather App
//
//  Created by Onur Sir on 27.05.2023.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coordinates
    var weatherData: WeatherData?
    
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}
